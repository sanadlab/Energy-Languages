#!/usr/bin/env python3
"""Generic loop-harness for C++ leetcode cells (cross-language transfer check).

C++ has NO runtime reflection, so we cannot dispatch generically the way the
Java/JS harnesses do. Instead we *generate a small per-problem driver* from the
method signature: parse the solution's `class Solution` method, marshal the
shared JSON input into the exact C++ argument types, then loop the call to a
wall-time budget (warmup uncounted, checksum-consumed, iteration-counted, with a
`volatile` sink so -O2 cannot DCE the loop body).

Contract (identical to Harness.java / harness.js), run FROM the cell directory:

    python3 harness_cpp.py <budget_seconds> <case_index>

  - slug derived from the cell dir name (C++/leetcode/<slug>/)
  - input  from  reference/leetcode/outputs/<slug>.json  -> expected[idx].input
  - method from  reference/leetcode/workloads/<slug>.json -> entry_point
  - generates driver.cpp, compiles `g++ -O2 -std=c++17`, runs the binary which
    prints  CASE=<name> ITERS=<n> ACC=<checksum> MEAS_S=<secs> BEACON=<result>
    to STDERR (stdout stays empty).

Handles plain-data signatures, TreeNode/ListNode problems (structures built from
the serialized level-order / array input, mirroring Harness.java's buildTree /
buildList), and design classes (input {ops,args} -> constructor + method replay,
re-instantiating and replaying the full op sequence every iteration).
"""
import json, os, re, subprocess, sys, tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REF  = os.path.join(ROOT, "reference", "leetcode")

# Problems LeetCode judges order-insensitively (special judge): multiset compare.
_UNORDERED = {"uncommon-words-from-two-sentences", "remove-invalid-parentheses",
              "restore-the-array-from-adjacent-pairs"}

# ---------------------------------------------------------------- signature parse
def _method_sig(src, method):
    """Return (return_type, raw_param_string) for `method` defined in src, or (None,None)."""
    for m in re.finditer(r'\b' + re.escape(method) + r'\s*\(', src):
        i = m.end() - 1
        depth = 0; j = i
        while j < len(src):
            if src[j] == '(': depth += 1
            elif src[j] == ')':
                depth -= 1
                if depth == 0: break
            j += 1
        params = src[i + 1:j]
        pre = src[:m.start()]
        k = max(pre.rfind(';'), pre.rfind('{'), pre.rfind('}'), pre.rfind(':'))
        ret = pre[k + 1:].strip()
        if ret and not ret.startswith('//'):
            return ret, params
    return None, None

def _sig_params(src, name):
    """Raw param string of the first *definition/declaration* `name(...)`, or None.

    Used for constructors (which have no return type, so _method_sig rejects them)
    and as a fallback for method-param extraction. A definition is recognised by the
    token right after the closing paren being one of `{ : ;` or const/override/noexcept.
    """
    for m in re.finditer(r'\b' + re.escape(name) + r'\s*\(', src):
        i = m.end() - 1
        depth = 0; j = i
        while j < len(src):
            if src[j] == '(': depth += 1
            elif src[j] == ')':
                depth -= 1
                if depth == 0: break
            j += 1
        k = j + 1
        while k < len(src) and src[k].isspace(): k += 1
        tail = src[k:k + 9]
        if src[k:k + 1] in ('{', ':', ';') or tail.startswith(('const', 'override', 'noexcept')):
            return src[i + 1:j]
    return None

def _split_params(p):
    out, depth, cur = [], 0, ''
    for c in p:
        if c in '<([{': depth += 1
        elif c in '>)]}': depth -= 1
        if c == ',' and depth == 0:
            out.append(cur); cur = ''
        else:
            cur += c
    if cur.strip(): out.append(cur)
    return out

def _param_type(param):
    param = param.split('=')[0].strip()
    mm = re.search(r'([A-Za-z_]\w*)\s*$', param)   # trailing identifier = arg name
    t = param[:mm.start()].strip() if mm else param
    return re.sub(r'\s+', ' ', t).strip()

def _norm(t):
    """Normalise a C++ type to a marshaller key: strip const/ref, collapse spaces."""
    t = t.replace('const', '').replace('&', '').strip()
    t = re.sub(r'\s+', '', t)               # remove all spaces: 'long long' -> 'longlong'
    return t

def _defines_struct(src, name):
    return re.search(r'\b(struct|class)\s+' + re.escape(name) + r'\b', src) is not None

# marshaller: normalised-type -> (to_fn, )
MARSHAL = {
    'int': 'to_int', 'longlong': 'to_ll', 'long': 'to_ll', 'double': 'to_double',
    'bool': 'to_bool', 'char': 'to_char', 'string': 'to_str',
    'vector<int>': 'to_vint', 'vector<longlong>': 'to_vll', 'vector<long>': 'to_vll',
    'vector<double>': 'to_vdouble', 'vector<bool>': 'to_vbool', 'vector<char>': 'to_vchar',
    'vector<string>': 'to_vstr',
    'vector<vector<int>>': 'to_vvint', 'vector<vector<string>>': 'to_vvstr',
    'vector<vector<char>>': 'to_vvchar', 'vector<vector<bool>>': 'to_vvbool',
    'vector<vector<double>>': 'to_vvdouble',
}

DEFER_TYPES = ('TreeNode', 'ListNode', 'Node')

def _marshal_for(raw):
    """Marshaller name for a raw (un-normalised) param type, incl. TreeNode*/ListNode*."""
    if 'TreeNode' in raw: return 'to_tree'
    if 'ListNode' in raw: return 'to_list'
    return MARSHAL.get(_norm(raw))

def analyze(slug):
    """-> dict(kind=, method=, ...) ; kind in plain/tree/list/design/unsupported.

    tree/list results also carry ret= (method return type) and praw= (raw param types).
    """
    wl = json.load(open(os.path.join(REF, "workloads", slug + ".json")))
    ep = wl.get("entry_point", "") or ""
    method = ep.split('.')[-1]
    out = json.load(open(os.path.join(REF, "outputs", slug + ".json")))
    inp = out["expected"][0]["input"]
    keys = list(inp.keys()) if isinstance(inp, dict) else []
    if isinstance(inp, dict) and "ops" in inp and "args" in inp:
        return dict(kind="design", method=method)
    src = open(os.path.join(ROOT, "C++", "leetcode", slug, "solution.cpp")).read()
    ret, params = _method_sig(src, method)
    kind = "tree" if "root" in keys else ("list" if "head" in keys else None)
    if ret is None:
        return dict(kind="unsupported", method=method,
                    reason="could not parse signature for '%s'" % method)
    praw = [_param_type(x) for x in _split_params(params)]
    if kind is None:                                    # infer from TreeNode/ListNode in sig
        if any(d in ret for d in DEFER_TYPES):
            kind = "list" if "ListNode" in ret else "tree"
        else:
            for raw in praw:
                if any(d in raw for d in DEFER_TYPES):
                    kind = "list" if "ListNode" in raw else "tree"
                    break
    if kind in ("tree", "list"):
        return dict(kind=kind, method=method, ret=ret, praw=praw)
    norm = [_norm(t) for t in praw]
    for n, raw in zip(norm, praw):
        if n not in MARSHAL:
            return dict(kind="unsupported", method=method, reason="unhandled param type '%s'" % raw)
    return dict(kind="plain", method=method, ret=ret, ptypes=norm)

# ---------------------------------------------------------------- C++ driver prelude
# Shared prelude: STL headers, (optional) TreeNode/ListNode defs, the solution, then
# the hz namespace (JSON parser + marshallers + checksum + canon), then secs_since().
# Placeholders: __PRE_INCLUDE__ (struct defs), __SOLUTION__ (path), __HZ_EXTRA__ (extra
# hz helpers for tree/list). Mains are appended per-kind.
PRELUDE = r'''
// Prelude mirrors the cells' own test_suite prelude (the STL bits LC's judge
// implicitly provides) + a few the harness itself needs. Avoids <bits/stdc++.h>
// so it also compiles under Apple clang for local verification.
#include <algorithm>
#include <array>
#include <bitset>
#include <cctype>
#include <chrono>
#include <climits>
#include <cmath>
#include <complex>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <deque>
#include <fstream>
#include <functional>
#include <iostream>
#include <iterator>
#include <list>
#include <map>
#include <numeric>
#include <queue>
#include <random>
#include <set>
#include <sstream>
#include <stack>
#include <string>
#include <tuple>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>
using namespace std;

__PRE_INCLUDE__
#include "__SOLUTION__"      // provides: class Solution (and, for some cells, TreeNode/ListNode)

namespace hz {
// ---------- minimal JSON parser (numbers kept as raw text -> lossless) ----------
struct JVal {
    enum T { NUL, BOOL, NUM, STR, ARR, OBJ } t = NUL;
    bool b = false; string str, raw;
    vector<JVal> arr;
    vector<pair<string, JVal>> obj;
};
struct JP {
    const string& s; size_t p = 0;
    JP(const string& in) : s(in) {}
    void ws() { while (p < s.size() && isspace((unsigned char)s[p])) p++; }
    JVal val() {
        ws(); char c = s[p];
        if (c == '{') return objj();
        if (c == '[') return arrj();
        if (c == '"') { JVal v; v.t = JVal::STR; v.str = strj(); return v; }
        if (c == 't') { p += 4; JVal v; v.t = JVal::BOOL; v.b = true;  return v; }
        if (c == 'f') { p += 5; JVal v; v.t = JVal::BOOL; v.b = false; return v; }
        if (c == 'n') { p += 4; JVal v; v.t = JVal::NUL; return v; }
        return numj();
    }
    string strj() {
        string b; p++;                       // opening quote
        while (p < s.size()) {
            char c = s[p++];
            if (c == '"') break;
            if (c == '\\') {
                char e = s[p++];
                switch (e) {
                    case 'n': b += '\n'; break; case 't': b += '\t'; break;
                    case 'r': b += '\r'; break; case 'b': b += '\b'; break;
                    case 'f': b += '\f'; break; case '/': b += '/';  break;
                    case '"': b += '"';  break; case '\\': b += '\\'; break;
                    case 'u': { int cp = stoi(s.substr(p, 4), nullptr, 16); p += 4;
                                if (cp < 128) b += (char)cp; else b += '?'; break; }
                    default: b += e;
                }
            } else b += c;
        }
        return b;
    }
    JVal numj() {
        size_t st = p;
        while (p < s.size() && (isdigit((unsigned char)s[p]) || strchr("+-.eE", s[p]))) p++;
        JVal v; v.t = JVal::NUM; v.raw = s.substr(st, p - st); return v;
    }
    JVal arrj() {
        JVal v; v.t = JVal::ARR; p++; ws();
        if (s[p] == ']') { p++; return v; }
        while (true) { v.arr.push_back(val()); ws();
            if (s[p] == ',') { p++; continue; } p++; break; }
        return v;
    }
    JVal objj() {
        JVal v; v.t = JVal::OBJ; p++; ws();
        if (s[p] == '}') { p++; return v; }
        while (true) { ws(); string k = strj(); ws(); p++;   // skip ':'
            v.obj.emplace_back(k, val()); ws();
            if (s[p] == ',') { p++; continue; } p++; break; }
        return v;
    }
};
const JVal* field(const JVal& o, const string& k) {
    for (auto& kv : o.obj) if (kv.first == k) return &kv.second;
    return nullptr;
}

// ---------- marshal parsed JSON -> typed C++ argument ----------
static long long jll(const JVal& j) { return j.raw.empty() ? 0 : stoll(j.raw); }
static int    to_int(const JVal& j)    { return (int)jll(j); }
static long long to_ll(const JVal& j)  { return jll(j); }
static double to_double(const JVal& j) { return j.raw.empty() ? 0.0 : stod(j.raw); }
static bool   to_bool(const JVal& j)   { return j.t == JVal::BOOL ? j.b : jll(j) != 0; }
static char   to_char(const JVal& j)   { return j.str.empty() ? '\0' : j.str[0]; }
static string to_str(const JVal& j)    { return j.str; }
static vector<int>       to_vint(const JVal& j)    { vector<int> r;       for (auto& e : j.arr) r.push_back(to_int(e));    return r; }
static vector<long long> to_vll(const JVal& j)     { vector<long long> r; for (auto& e : j.arr) r.push_back(to_ll(e));     return r; }
static vector<double>    to_vdouble(const JVal& j) { vector<double> r;    for (auto& e : j.arr) r.push_back(to_double(e)); return r; }
static vector<bool>      to_vbool(const JVal& j)   { vector<bool> r;      for (auto& e : j.arr) r.push_back(to_bool(e));   return r; }
static vector<char>      to_vchar(const JVal& j)   { vector<char> r;      for (auto& e : j.arr) r.push_back(to_char(e));   return r; }
static vector<string>    to_vstr(const JVal& j)    { vector<string> r;    for (auto& e : j.arr) r.push_back(to_str(e));    return r; }
static vector<vector<int>>    to_vvint(const JVal& j)    { vector<vector<int>> r;    for (auto& e : j.arr) r.push_back(to_vint(e));    return r; }
static vector<vector<string>> to_vvstr(const JVal& j)    { vector<vector<string>> r; for (auto& e : j.arr) r.push_back(to_vstr(e));    return r; }
static vector<vector<char>>   to_vvchar(const JVal& j)   { vector<vector<char>> r;   for (auto& e : j.arr) r.push_back(to_vchar(e));   return r; }
static vector<vector<bool>>   to_vvbool(const JVal& j)   { vector<vector<bool>> r;   for (auto& e : j.arr) r.push_back(to_vbool(e));   return r; }
static vector<vector<double>> to_vvdouble(const JVal& j) { vector<vector<double>> r; for (auto& e : j.arr) r.push_back(to_vdouble(e)); return r; }

// ---------- checksum (fold result -> long long, so it isn't optimised away) ----------
static inline long long cs(long long x) { return x; }
static inline long long cs(int x)       { return x; }
static inline long long cs(char x)      { return (long long)(unsigned char)x; }
static inline long long cs(bool x)      { return x ? 1 : 0; }
static inline long long cs(double x)    { return (long long)llround(x * 1e6); }
static inline long long cs(const string& s) { long long h = 1125899906842597LL; for (unsigned char c : s) h = h * 131 + c; return h; }
static inline long long cs(const vector<bool>& v) { long long h = (long long)v.size() + 1; for (bool b : v) h = h * 1000003 + (b ? 1 : 0); return h; }
template <class T> long long cs(const vector<T>& v) { long long h = (long long)v.size() + 1; for (const auto& e : v) h = h * 1000003 + cs(e); return h; }

// ---------- canonical string repr (for the BEACON / correctness compare) ----------
static string canon(long long x) { return to_string(x); }
static string canon(int x)       { return to_string(x); }
static string canon(bool x)      { return x ? "true" : "false"; }
static string canon(char x)      { return string("\"") + x + "\""; }
static string canon(double x)    { if (std::isfinite(x) && x == std::floor(x) && std::fabs(x) < 9.007199254740992e15) return to_string((long long)x); char buf[64]; snprintf(buf, sizeof buf, "%.6g", x); return buf; }
static string canon(const string& s) {
    string o = "\"";
    for (char c : s) { if (c == '"' || c == '\\') o += '\\'; o += c; }
    return o + "\"";
}
static string canon(const vector<bool>& v) { string o = "["; for (size_t i = 0; i < v.size(); i++) { if (i) o += ','; o += (v[i] ? "true" : "false"); } return o + "]"; }
template <class T> string canon(const vector<T>& v) { string o = "["; for (size_t i = 0; i < v.size(); i++) { if (i) o += ','; o += canon(v[i]); } return o + "]"; }
__HZ_EXTRA__
} // namespace hz

static double secs_since(const std::chrono::steady_clock::time_point& t) {
    return std::chrono::duration<double>(std::chrono::steady_clock::now() - t).count();
}

// canonical string of a parsed EXPECTED json value, in the SAME textual form
// hz::canon gives the corresponding result (integers via to_string, arrays with
// no spaces, strings quoted). Used only by the `validate` driver.
[[maybe_unused]] static std::string canonJVal(const hz::JVal& j) {
    switch (j.t) {
        case hz::JVal::NUL:  return "null";
        case hz::JVal::BOOL: return j.b ? "true" : "false";
        case hz::JVal::STR:  return hz::canon(j.str);
        case hz::JVal::NUM: {
            const std::string& r = j.raw;
            if (r.find('.') != std::string::npos || r.find('e') != std::string::npos || r.find('E') != std::string::npos) {
                double d = r.empty() ? 0.0 : std::stod(r);
                if (std::isfinite(d) && d == std::floor(d) && std::fabs(d) < 9.007199254740992e15) return std::to_string((long long)d);
                char buf[64]; snprintf(buf, sizeof buf, "%.6g", d); return buf;
            }
            return std::to_string(r.empty() ? 0LL : std::stoll(r));
        }
        case hz::JVal::ARR: {
            std::string o = "[";
            for (size_t i = 0; i < j.arr.size(); i++) { if (i) o += ','; o += canonJVal(j.arr[i]); }
            return o + "]";
        }
        default: return "null";
    }
}
// multiset (order-insensitive) canon: sort element canons. Only used by the
// `validate` driver for special-judge problems.
[[maybe_unused]] static std::string canonJVal_multiset(const hz::JVal& j) {
    if (j.t != hz::JVal::ARR) return canonJVal(j);
    std::vector<std::string> parts;
    for (auto& e : j.arr) parts.push_back(canonJVal(e));
    std::sort(parts.begin(), parts.end());
    std::string o = "["; for (size_t i = 0; i < parts.size(); i++) { if (i) o += ','; o += parts[i]; } return o + "]";
}
namespace hz {
template <class T> std::string canon_multiset(const std::vector<T>& v) {
    std::vector<std::string> parts;
    for (auto& e : v) parts.push_back(canon(e));
    std::sort(parts.begin(), parts.end());
    std::string o = "["; for (size_t i = 0; i < parts.size(); i++) { if (i) o += ','; o += parts[i]; } return o + "]";
}
} // namespace hz
'''

# ---------------------------------------------------------------- mains
# Plain / tree / list share this main: __BUILD_ARGS__ defines a `do_call` lambda
# returning the (canon/cs-able) result; the loop folds it into a checksum.
MAIN_PLAIN = r'''
int main(int argc, char** argv) {
    if (argc < 3) { fprintf(stderr, "usage: driver <budget_seconds> <case_index>\n"); return 2; }
    double budget = atof(argv[1]);
    int    idx    = atoi(argv[2]);

    std::ifstream f("__OUTPUTS__");
    std::stringstream ss; ss << f.rdbuf();
    std::string text = ss.str();
    hz::JVal doc = hz::JP(text).val();
    const hz::JVal* expected = hz::field(doc, "expected");
    const hz::JVal& kase = expected->arr[idx];
    const hz::JVal* nameV = hz::field(kase, "name");
    std::string name = nameV ? nameV->str : "case";
    const hz::JVal* input = hz::field(kase, "input");
    auto& E = input->obj;                       // entries in signature order

__BUILD_ARGS__

    long long acc = 0, iters = 0;
    double warm = budget * 0.3;
    long long wi = 0;
    auto t0 = std::chrono::steady_clock::now();
    while (secs_since(t0) < warm) { volatile long long z = hz::cs(do_call()); (void)z; wi++; }
    double per = wi ? (secs_since(t0) / wi) : warm;    // (3) batch the clock read
    long long batch = 4096; if (per > 0) { long long bb = (long long)(0.002 / per); batch = bb < 1 ? 1 : (bb > 4096 ? 4096 : bb); }
    auto tm = std::chrono::steady_clock::now();
    while (secs_since(tm) < budget - warm) { for (long long b = 0; b < batch; b++) { acc = acc * 1000003 + hz::cs(do_call()); } iters += batch; }
    double meas = secs_since(tm);
    volatile long long sink = acc; (void)sink;   // defeat dead-code elimination

    std::string beacon = hz::canon(do_call());
    fprintf(stderr, "CASE=%s ITERS=%lld ACC=%lld MEAS_S=%.6f BEACON=%s\n",
            name.c_str(), iters, acc, meas, beacon.c_str());
    return 0;
}
'''

# Design main: replay the {ops,args} op sequence, re-instantiating the class and
# deep-marshalling args from JSON each iteration (mutation safety). do_replay folds
# every op return into a checksum; passing a non-null results vector records the
# per-op output slot (ctor slot + void method -> "null") for offline verification.
MAIN_DESIGN = r'''
int main(int argc, char** argv) {
    if (argc < 3) { fprintf(stderr, "usage: driver <budget_seconds> <case_index>\n"); return 2; }
    double budget = atof(argv[1]);
    int    idx    = atoi(argv[2]);

    std::ifstream f("__OUTPUTS__");
    std::stringstream ss; ss << f.rdbuf();
    std::string text = ss.str();
    hz::JVal doc = hz::JP(text).val();
    const hz::JVal* expected = hz::field(doc, "expected");
    const hz::JVal& kase = expected->arr[idx];
    const hz::JVal* nameV = hz::field(kase, "name");
    std::string name = nameV ? nameV->str : "case";
    const hz::JVal* input = hz::field(kase, "input");
    const std::vector<hz::JVal>& OPS = hz::field(*input, "ops")->arr;
    const std::vector<hz::JVal>& ARG = hz::field(*input, "args")->arr;

    auto do_replay = [&](std::vector<std::string>* results) -> long long {
        long long h = 0;
__CONSTRUCT__
        for (size_t i = 1; i < OPS.size(); i++) {
            const std::string& op = OPS[i].str;
            const hz::JVal& aa = ARG[i]; (void)aa;
__DISPATCH__
        }
        return h;
    };

    long long acc = 0, iters = 0;
    double warm = budget * 0.3;
    long long wi = 0;
    auto t0 = std::chrono::steady_clock::now();
    while (secs_since(t0) < warm) { volatile long long z = do_replay(nullptr); (void)z; wi++; }
    double per = wi ? (secs_since(t0) / wi) : warm;    // (3) batch the clock read
    long long batch = 4096; if (per > 0) { long long bb = (long long)(0.002 / per); batch = bb < 1 ? 1 : (bb > 4096 ? 4096 : bb); }
    auto tm = std::chrono::steady_clock::now();
    while (secs_since(tm) < budget - warm) { for (long long b = 0; b < batch; b++) { acc = acc * 1000003 + do_replay(nullptr); } iters += batch; }
    double meas = secs_since(tm);
    volatile long long sink = acc; (void)sink;   // defeat dead-code elimination

    fprintf(stderr, "CASE=%s ITERS=%lld ACC=%lld MEAS_S=%.6f BEACON=design\n",
            name.c_str(), iters, acc, meas);
    return 0;
}
'''

# ---------------------------------------------------------------- validate mains
# Full-suite correctness validation: ONE compiled binary loops EVERY reference
# case, runs it once, and compares to the expected output. Design/trace cases
# skip null-expected positions (void ops LeetCode discards). Exit: 0 Accepted,
# 1 Wrong Answer, 3 Runtime Error.
MAIN_VALIDATE_PLAIN = r'''
int main(int argc, char** argv) {
    (void)argc; (void)argv;
    std::ifstream f("__OUTPUTS__");
    std::stringstream ss; ss << f.rdbuf();
    std::string text = ss.str();
    hz::JVal doc = hz::JP(text).val();
    const std::string slug = "__SLUG__";
    const hz::JVal* expected = hz::field(doc, "expected");
    for (size_t ci = 0; ci < expected->arr.size(); ci++) {
        const hz::JVal& kase = expected->arr[ci];
        const hz::JVal* nameV = hz::field(kase, "name");
        std::string name = nameV ? nameV->str : "case";
        const hz::JVal* input = hz::field(kase, "input");
        auto& E = input->obj; (void)E;
        const hz::JVal* outV = hz::field(kase, "output");
        std::string actual;
        try {
__BUILD_INLINE__
        } catch (const std::exception& e) {
            fprintf(stderr, "VALIDATE slug=%s RE case=%s passed=%zu ncases=%zu %s\n", slug.c_str(), name.c_str(), ci, expected->arr.size(), e.what());
            return 3;
        }
        std::string exp = outV ? __EXP_EXPR__ : std::string("null");
        if (exp != actual) {
            fprintf(stderr, "VALIDATE slug=%s FAIL case=%s passed=%zu ncases=%zu expected=%s actual=%s\n",
                    slug.c_str(), name.c_str(), ci, expected->arr.size(), exp.substr(0, 120).c_str(), actual.substr(0, 120).c_str());
            return 1;
        }
    }
    fprintf(stderr, "VALIDATE slug=%s PASS ncases=%zu passed=%zu\n", slug.c_str(), expected->arr.size(), expected->arr.size());
    return 0;
}
'''

MAIN_VALIDATE_DESIGN = r'''
int main(int argc, char** argv) {
    (void)argc; (void)argv;
    std::ifstream f("__OUTPUTS__");
    std::stringstream ss; ss << f.rdbuf();
    std::string text = ss.str();
    hz::JVal doc = hz::JP(text).val();
    const std::string slug = "__SLUG__";
    const bool randomized = __RANDOMIZED__;
    const hz::JVal* expected = hz::field(doc, "expected");
    for (size_t ci = 0; ci < expected->arr.size(); ci++) {
        const hz::JVal& kase = expected->arr[ci];
        const hz::JVal* nameV = hz::field(kase, "name");
        std::string name = nameV ? nameV->str : "case";
        const hz::JVal* input = hz::field(kase, "input");
        const std::vector<hz::JVal>& OPS = hz::field(*input, "ops")->arr;
        const std::vector<hz::JVal>& ARG = hz::field(*input, "args")->arr;
        std::vector<std::string> resVec;
        std::vector<std::string>* results = &resVec;
        try {
            long long h = 0; (void)h;
__CONSTRUCT__
            for (size_t i = 1; i < OPS.size(); i++) {
                const std::string& op = OPS[i].str;
                const hz::JVal& aa = ARG[i]; (void)aa;
__DISPATCH__
            }
        } catch (const std::exception& e) {
            fprintf(stderr, "VALIDATE slug=%s RE case=%s passed=%zu ncases=%zu %s\n", slug.c_str(), name.c_str(), ci, expected->arr.size(), e.what());
            return 3;
        }
        // random-pick: pick returns a valid index; reference stores nums[index].
        if (randomized) {
            const hz::JVal& nums = ARG[0].arr[0];
            for (size_t i = 1; i < OPS.size(); i++)
                if (OPS[i].str == "pick" && i < resVec.size())
                    resVec[i] = canonJVal(nums.arr[(size_t)std::stoll(resVec[i])]);
        }
        const hz::JVal* outV = hz::field(kase, "output");
        const std::vector<hz::JVal>& exp = outV->arr;
        if (exp.size() != resVec.size()) {
            fprintf(stderr, "VALIDATE slug=%s FAIL case=%s passed=%zu ncases=%zu size exp=%zu act=%zu\n",
                    slug.c_str(), name.c_str(), ci, expected->arr.size(), exp.size(), resVec.size());
            return 1;
        }
        for (size_t i = 0; i < exp.size(); i++) {
            if (exp[i].t == hz::JVal::NUL) continue;   // void op: not compared
            std::string e2 = canonJVal(exp[i]);
            if (e2 != resVec[i]) {
                fprintf(stderr, "VALIDATE slug=%s FAIL case=%s passed=%zu ncases=%zu pos=%zu expected=%s actual=%s\n",
                        slug.c_str(), name.c_str(), ci, expected->arr.size(), i, e2.c_str(), resVec[i].c_str());
                return 1;
            }
        }
    }
    fprintf(stderr, "VALIDATE slug=%s PASS ncases=%zu passed=%zu\n", slug.c_str(), expected->arr.size(), expected->arr.size());
    return 0;
}
'''

# ---------------------------------------------------------------- tree/list scaffolding
STD_TREENODE = ("struct TreeNode { int val; TreeNode *left; TreeNode *right; "
                "TreeNode(int x): val(x), left(nullptr), right(nullptr) {} };\n")
STD_LISTNODE = ("struct ListNode { int val; ListNode *next; "
                "ListNode(int x): val(x), next(nullptr) {} };\n")

HZ_TREE = r'''
// ---------- build TreeNode from level-order list (null = missing child) ----------
static TreeNode* to_tree(const JVal& j) {
    if (j.t != JVal::ARR || j.arr.empty() || j.arr[0].t == JVal::NUL) return nullptr;
    TreeNode* root = new TreeNode(to_int(j.arr[0]));
    std::queue<TreeNode*> q; q.push(root);
    size_t i = 1;
    while (i < j.arr.size() && !q.empty()) {
        TreeNode* n = q.front(); q.pop();
        if (i < j.arr.size()) { const JVal& lv = j.arr[i++]; if (lv.t != JVal::NUL) { n->left  = new TreeNode(to_int(lv)); q.push(n->left);  } }
        if (i < j.arr.size()) { const JVal& rv = j.arr[i++]; if (rv.t != JVal::NUL) { n->right = new TreeNode(to_int(rv)); q.push(n->right); } }
    }
    return root;
}
static void freeTree(TreeNode* n) { if (!n) return; freeTree(n->left); freeTree(n->right); delete n; }
'''

HZ_LIST = r'''
// ---------- build ListNode from array; serialise a sublist back to int values ----
static ListNode* to_list(const JVal& j) {
    if (j.t != JVal::ARR || j.arr.empty()) return nullptr;
    ListNode* head = new ListNode(to_int(j.arr[0])); ListNode* cur = head;
    for (size_t i = 1; i < j.arr.size(); i++) { cur->next = new ListNode(to_int(j.arr[i])); cur = cur->next; }
    return head;
}
static void freeList(ListNode* n) { while (n) { ListNode* nx = n->next; delete n; n = nx; } }
static std::vector<int> listVals(ListNode* n) { std::vector<int> r; while (n) { r.push_back(n->val); n = n->next; } return r; }
'''

# ---------------------------------------------------------------- code generation
def _prelude(sol, pre="", hz_extra=""):
    return (PRELUDE
            .replace("__PRE_INCLUDE__", pre)
            .replace("__HZ_EXTRA__", hz_extra)
            .replace("__SOLUTION__", sol))

def gen_driver(slug, info):
    sol = os.path.join(ROOT, "C++", "leetcode", slug, "solution.cpp")
    outs = os.path.join(REF, "outputs", slug + ".json")
    lines, callargs = [], []
    for i, t in enumerate(info["ptypes"]):
        fn = MARSHAL[t]
        lines.append("    auto base%d = hz::%s(E[%d].second);" % (i, fn, i))
        callargs.append("a%d" % i)
    copies = " ".join("auto a%d = base%d;" % (i, i) for i in range(len(callargs)))
    build = "\n".join(lines) + "\n\n"
    build += "    auto do_call = [&]() {\n"
    build += "        Solution sol;\n"
    build += "        " + copies + "\n"
    build += "        return sol.%s(%s);\n" % (info["method"], ", ".join(callargs))
    build += "    };"
    return _prelude(sol) + MAIN_PLAIN.replace("__OUTPUTS__", outs).replace("__BUILD_ARGS__", build)

def gen_driver_treelist(slug, info):
    sol = os.path.join(ROOT, "C++", "leetcode", slug, "solution.cpp")
    outs = os.path.join(REF, "outputs", slug + ".json")
    src_txt = open(sol).read()
    kind, praw, ret = info["kind"], info["praw"], info["ret"]
    pre = ""
    if kind == "tree" and not _defines_struct(src_txt, "TreeNode"): pre = STD_TREENODE
    if kind == "list" and not _defines_struct(src_txt, "ListNode"): pre = STD_LISTNODE
    hz_extra = HZ_TREE if kind == "tree" else HZ_LIST

    lines, callargs, frees = [], [], []
    for i, raw in enumerate(praw):
        lines.append("        auto a%d = hz::%s(E[%d].second);" % (i, _marshal_for(raw), i))
        callargs.append("a%d" % i)
        if 'TreeNode' in raw: frees.append("        hz::freeTree(a%d);" % i)
        elif 'ListNode' in raw: frees.append("        hz::freeList(a%d);" % i)
    call = "sol.%s(%s)" % (info["method"], ", ".join(callargs))

    body = ["    auto do_call = [&]() {", "        Solution sol;"] + lines
    if 'ListNode' in ret:               # result is a node -> serialise sublist -> int array
        body.append("        ListNode* _r = %s;" % call)
        body.append("        std::vector<int> _res = hz::listVals(_r);")
        body += frees
        body.append("        return _res;")
    else:                               # scalar result (bool/int/...); free the built structure
        body.append("        auto _r = %s;" % call)
        body += frees
        body.append("        return _r;")
    body.append("    };")
    build = "\n".join(body)
    return (_prelude(sol, pre, hz_extra)
            + MAIN_PLAIN.replace("__OUTPUTS__", outs).replace("__BUILD_ARGS__", build))

def _design_parts(slug):
    """Shared construct+dispatch codegen for the design driver (measure + validate)."""
    sol = os.path.join(ROOT, "C++", "leetcode", slug, "solution.cpp")
    src_txt = open(sol).read()
    outs = os.path.join(REF, "outputs", slug + ".json")
    cases = json.load(open(outs))["expected"]
    ops0 = cases[0]["input"]["ops"][0]

    real_ctor = _defines_struct(src_txt, ops0)
    if real_ctor:
        className = ops0
        ctor_params = _sig_params(src_txt, className) or ""
    else:
        className = "Solution"
        _r, ctor_params = _method_sig(src_txt, ops0)
        if ctor_params is None:
            ctor_params = _sig_params(src_txt, ops0) or ""
    cparams = [_param_type(x) for x in _split_params(ctor_params)] if ctor_params.strip() else []
    cons = ["        auto c%d = hz::%s(ARG[0].arr[%d]);" % (j, _marshal_for(raw), j)
            for j, raw in enumerate(cparams)]
    cargs = ", ".join("c%d" % j for j in range(len(cparams)))
    con = []
    if real_ctor:
        con += cons
        con.append("        %s obj%s;" % (className, ("(" + cargs + ")") if cparams else ""))
    else:
        con.append("        %s obj;" % className)
        con += cons
        con.append("        obj.%s(%s);" % (ops0, cargs))
    con.append('        if (results) results->push_back("null");')  # ctor output slot is always null
    construct = "\n".join(con)

    names, seen = [], set()
    for c in cases:
        for o in c["input"]["ops"][1:]:
            if o not in seen: seen.add(o); names.append(o)
    branches = []
    for n_i, name in enumerate(names):
        ret, params = _method_sig(src_txt, name)
        if params is None:
            params = _sig_params(src_txt, name) or ""
        void = (ret is not None and ret.strip() == "void")
        mpraw = [_param_type(x) for x in _split_params(params)] if params.strip() else []
        b = ['            %s (op == "%s") {' % ("if" if n_i == 0 else "else if", name)]
        margs = []
        for j, raw in enumerate(mpraw):
            b.append("                auto p%d = hz::%s(aa.arr[%d]);" % (j, _marshal_for(raw), j))
            margs.append("p%d" % j)
        callexpr = "obj.%s(%s)" % (name, ", ".join(margs))
        if void:
            b.append("                %s;" % callexpr)
            b.append("                h = h * 1000003 + 3;")
            b.append('                if (results) results->push_back("null");')
        else:
            b.append("                auto rv = %s;" % callexpr)
            b.append("                h = h * 1000003 + hz::cs(rv);")
            b.append("                if (results) results->push_back(hz::canon(rv));")
        b.append("            }")
        branches.append("\n".join(b))
    dispatch = "\n".join(branches)
    return construct, dispatch


def gen_driver_design(slug):
    sol = os.path.join(ROOT, "C++", "leetcode", slug, "solution.cpp")
    outs = os.path.join(REF, "outputs", slug + ".json")
    construct, dispatch = _design_parts(slug)
    return (_prelude(sol)
            + MAIN_DESIGN.replace("__OUTPUTS__", outs)
                         .replace("__CONSTRUCT__", construct)
                         .replace("__DISPATCH__", dispatch))


def gen_validate_plain(slug, info):
    sol = os.path.join(ROOT, "C++", "leetcode", slug, "solution.cpp")
    outs = os.path.join(REF, "outputs", slug + ".json")
    lines, callargs = [], []
    for i, t in enumerate(info["ptypes"]):
        fn = MARSHAL[t]
        lines.append("            auto base%d = hz::%s(E[%d].second);" % (i, fn, i))
        callargs.append("a%d" % i)
    copies = " ".join("auto a%d = base%d;" % (i, i) for i in range(len(callargs)))
    unordered = slug in _UNORDERED
    canon_fn = "hz::canon_multiset" if unordered else "hz::canon"
    exp_expr = "canonJVal_multiset(*outV)" if unordered else "canonJVal(*outV)"
    body = "\n".join(lines) + "\n            Solution sol;\n            " + copies + "\n"
    body += "            actual = %s(sol.%s(%s));" % (canon_fn, info["method"], ", ".join(callargs))
    return (_prelude(sol)
            + MAIN_VALIDATE_PLAIN.replace("__OUTPUTS__", outs)
                                 .replace("__SLUG__", slug)
                                 .replace("__EXP_EXPR__", exp_expr)
                                 .replace("__BUILD_INLINE__", body))


def gen_validate_treelist(slug, info):
    sol = os.path.join(ROOT, "C++", "leetcode", slug, "solution.cpp")
    outs = os.path.join(REF, "outputs", slug + ".json")
    src_txt = open(sol).read()
    kind, praw, ret = info["kind"], info["praw"], info["ret"]
    pre = ""
    if kind == "tree" and not _defines_struct(src_txt, "TreeNode"): pre = STD_TREENODE
    if kind == "list" and not _defines_struct(src_txt, "ListNode"): pre = STD_LISTNODE
    hz_extra = HZ_TREE if kind == "tree" else HZ_LIST
    lines, callargs, frees = [], [], []
    for i, raw in enumerate(praw):
        lines.append("            auto a%d = hz::%s(E[%d].second);" % (i, _marshal_for(raw), i))
        callargs.append("a%d" % i)
        if 'TreeNode' in raw: frees.append("            hz::freeTree(a%d);" % i)
        elif 'ListNode' in raw: frees.append("            hz::freeList(a%d);" % i)
    call = "sol.%s(%s)" % (info["method"], ", ".join(callargs))
    body = ["            Solution sol;"] + lines
    if 'ListNode' in ret:
        body.append("            ListNode* _r = %s;" % call)
        body.append("            std::vector<int> _res = hz::listVals(_r);")
        body += frees
        body.append("            actual = hz::canon(_res);")
    else:
        body.append("            auto _r = %s;" % call)
        body += frees
        body.append("            actual = hz::canon(_r);")
    return (_prelude(sol, pre, hz_extra)
            + MAIN_VALIDATE_PLAIN.replace("__OUTPUTS__", outs)
                                 .replace("__SLUG__", slug)
                                 .replace("__EXP_EXPR__", "canonJVal(*outV)")
                                 .replace("__BUILD_INLINE__", "\n".join(body)))


def gen_validate_design(slug):
    sol = os.path.join(ROOT, "C++", "leetcode", slug, "solution.cpp")
    outs = os.path.join(REF, "outputs", slug + ".json")
    construct, dispatch = _design_parts(slug)
    randomized = "true" if slug == "random-pick-index" else "false"
    return (_prelude(sol)
            + MAIN_VALIDATE_DESIGN.replace("__OUTPUTS__", outs)
                                  .replace("__SLUG__", slug)
                                  .replace("__RANDOMIZED__", randomized)
                                  .replace("__CONSTRUCT__", construct)
                                  .replace("__DISPATCH__", dispatch))


def build_and_validate(slug, keep=False):
    """Compile ONE validate driver and run it over every case. Returns the
    binary's exit code (0 Accepted, 1 Wrong Answer, 3 Runtime Error) or 2 on a
    setup/compile error so the caller can fall back to the legacy path."""
    info = analyze(slug)
    kind = info["kind"]
    if kind == "plain":
        src = gen_validate_plain(slug, info)
    elif kind in ("tree", "list"):
        src = gen_validate_treelist(slug, info)
    elif kind == "design":
        src = gen_validate_design(slug)
    else:
        sys.stderr.write("VALIDATE slug=%s ERROR unsupported kind=%s\n" % (slug, kind))
        return 2
    tmp = tempfile.mkdtemp(prefix="hz_cppv_")
    cpp = os.path.join(tmp, "driver.cpp"); binp = os.path.join(tmp, "driver")
    open(cpp, "w").write(src)
    cc = subprocess.run(["g++", "-O2", "-std=c++17", cpp, "-o", binp],
                        capture_output=True, text=True)
    if cc.returncode != 0:
        sys.stderr.write("VALIDATE slug=%s ERROR compile: %s\n" %
                         (slug, cc.stderr.strip().splitlines()[-1] if cc.stderr else ""))
        if keep:
            sys.stderr.write(src)
        else:
            try: os.remove(cpp); os.rmdir(tmp)
            except OSError: pass
        return 2
    celldir = os.path.join(ROOT, "C++", "leetcode", slug)
    rr = subprocess.run([binp], capture_output=True, text=True, cwd=celldir, timeout=300)
    if rr.stderr:
        sys.stderr.write(rr.stderr)
    if not keep:
        try: os.remove(cpp); os.remove(binp); os.rmdir(tmp)
        except OSError: pass
    return rr.returncode


def build_and_run(slug, budget, idx, keep=False):
    info = analyze(slug)
    kind = info["kind"]
    if kind == "plain":
        src = gen_driver(slug, info)
    elif kind in ("tree", "list"):
        src = gen_driver_treelist(slug, info)
    elif kind == "design":
        src = gen_driver_design(slug)
    else:
        return kind, info.get("reason", ""), None
    tmp = tempfile.mkdtemp(prefix="hz_cpp_")
    cpp = os.path.join(tmp, "driver.cpp")
    binp = os.path.join(tmp, "driver")
    open(cpp, "w").write(src)
    cc = subprocess.run(["g++", "-O2", "-std=c++17", cpp, "-o", binp],
                        capture_output=True, text=True)
    if cc.returncode != 0:
        if keep: print(src[:400], file=sys.stderr)
        return "compile_error", cc.stderr.strip().splitlines()[-1] if cc.stderr else "", None
    celldir = os.path.join(ROOT, "C++", "leetcode", slug)
    rr = subprocess.run([binp, str(budget), str(idx)], capture_output=True,
                        text=True, cwd=celldir, timeout=max(30, budget * 4 + 20))
    if not keep:
        try:
            os.remove(cpp); os.remove(binp); os.rmdir(tmp)
        except OSError:
            pass
    if rr.returncode != 0:
        return "runtime_error", (rr.stderr.strip().splitlines()[-1] if rr.stderr else "rc=%d" % rr.returncode), None
    return "ok", rr.stderr.strip(), src

# ---------------------------------------------------------------- contract CLI
def main():
    if len(sys.argv) > 1 and sys.argv[1] == "validate":
        slug = os.path.basename(os.getcwd())
        sys.exit(build_and_validate(slug))
    budget = float(sys.argv[1]) if len(sys.argv) > 1 else 1.0
    idx    = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    slug   = os.path.basename(os.getcwd())
    status, msg, _ = build_and_run(slug, budget, idx)
    if status == "ok":
        print(msg, file=sys.stderr)
    else:
        print("TODO/%s %s: %s" % (status, slug, msg), file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
