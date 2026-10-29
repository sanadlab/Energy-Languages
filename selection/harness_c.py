#!/usr/bin/env python3
"""C full-suite validator + perf harness for the leetcode cells.

C is the odd one out: its LeetCode calling convention is unique — arrays are
passed as a `ptr, size` pair, 2-D arrays as `ptr, size, colSizes`, and results
come back through `malloc` + out-params (`returnSize`, `returnColumnSizes`).
There is no object to reflect on and no STL to canonicalise with.

The trick: that whole convention is a DETERMINISTIC function of the logical
(C++) signature. So we reuse harness_cpp.analyze() to recover the logical shape
(method, kind, return type, param types) and the C++ `hz` namespace (JSON parse
+ canonicalisation), then:

  * compile the model's solution.c with **gcc** (C-as-C++ breaks on un-cast
    malloc), producing solution.o;
  * generate a C++ driver that declares the solution `extern "C"`, marshals
    each JSON case into C values (building the ptr/size/out-param plumbing),
    calls it, marshals the result back to an `hz`-canonical string, and
    compares to the expected output;
  * link driver.o + solution.o and run it over every reference case.

Contract (run FROM the cell dir, like harness_cpp.py):
    python3 harness_c.py validate       -> exit 0/1/3 (Accepted/WA/RE), 2 on setup
    python3 harness_c.py <budget> <idx>  -> perf line on stderr

Deterministic C-convention map (logical C++ type -> C params / C return):
    int/long/double/bool/char   scalar, 1 param
    string                      char*                       (return: char*)
    vector<int>                 int*  , int  size           (return: int*  + returnSize)
    vector<bool>                bool* , int  size           (return: bool* + returnSize)
    vector<double>              double*,int  size           (return: double*+ returnSize)
    vector<char>                char* , int  size
    vector<string>              char**, int  size           (return: char**+ returnSize)
    vector<vector<int>>         int** , int  size, int* col (return: int** + returnSize + returnColumnSizes)
    vector<vector<char>>        char**, int  size, int* col
    TreeNode*/ListNode*         struct TreeNode*/ListNode*
"""
import json, os, shutil, subprocess, sys, tempfile
import harness_cpp as cpp

ROOT = cpp.ROOT
REF  = cpp.REF
_UNORDERED = cpp._UNORDERED


# ── C-side node structs + tree/list builders (aggregate init, no ctors) ────────
C_NODES = (
    "struct TreeNode { int val; struct TreeNode *left; struct TreeNode *right; };\n"
    "struct ListNode { int val; struct ListNode *next; };\n"
)

# Headers LeetCode's C judge implicitly provides — models routinely use NULL,
# malloc, memset, strlen, INT_MAX, isdigit, etc. without an #include. We prepend
# them so a starter-style solution.c compiles standalone (mirrors the C++
# harness prepending the STL headers the judge implicitly provides).
C_STD_PRELUDE = (
    "#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n"
    "#include <stdbool.h>\n#include <math.h>\n#include <limits.h>\n"
    "#include <ctype.h>\n#include <stdint.h>\n"
)

# Nodes come from malloc, as in LeetCode's C judge, so a solution may free() them.
HZ_TREE_C = r'''
static TreeNode* new_tnode(int v) { TreeNode* n = (TreeNode*)malloc(sizeof(TreeNode)); n->val = v; n->left = n->right = nullptr; return n; }
static TreeNode* to_tree(const JVal& j) {
    if (j.t != JVal::ARR || j.arr.empty() || j.arr[0].t == JVal::NUL) return nullptr;
    TreeNode* root = new_tnode(to_int(j.arr[0]));
    std::queue<TreeNode*> q; q.push(root);
    size_t i = 1;
    while (i < j.arr.size() && !q.empty()) {
        TreeNode* n = q.front(); q.pop();
        if (i < j.arr.size()) { const JVal& lv = j.arr[i++]; if (lv.t != JVal::NUL) { n->left  = new_tnode(to_int(lv)); q.push(n->left);  } }
        if (i < j.arr.size()) { const JVal& rv = j.arr[i++]; if (rv.t != JVal::NUL) { n->right = new_tnode(to_int(rv)); q.push(n->right); } }
    }
    return root;
}
static void freeTree(TreeNode* n) { if (!n) return; freeTree(n->left); freeTree(n->right); free(n); }
static std::vector<int> treeVals_level(TreeNode* r) { std::vector<int> o; std::queue<TreeNode*> q; if (r) q.push(r); while(!q.empty()){ TreeNode* n=q.front(); q.pop(); o.push_back(n->val); if(n->left)q.push(n->left); if(n->right)q.push(n->right);} return o; }
'''

HZ_LIST_C = r'''
static ListNode* new_lnode(int v) { ListNode* n = (ListNode*)malloc(sizeof(ListNode)); n->val = v; n->next = nullptr; return n; }
static ListNode* to_list(const JVal& j) {
    if (j.t != JVal::ARR || j.arr.empty()) return nullptr;
    ListNode* head = new_lnode(to_int(j.arr[0])); ListNode* cur = head;
    for (size_t i = 1; i < j.arr.size(); i++) { cur->next = new_lnode(to_int(j.arr[i])); cur = cur->next; }
    return head;
}
static void freeList(ListNode* n) { while (n) { ListNode* nx = n->next; free(n); n = nx; } }
static std::vector<int> listVals(ListNode* n) { std::vector<int> r; while (n) { r.push_back(n->val); n = n->next; } return r; }
'''


# ── logical C++ type -> C declaration fragment(s) ──────────────────────────────
# Returns (c_param_types) for the extern "C" declaration, in order.
_SCALAR_C = {
    "int": "int", "long": "long long", "longlong": "long long",
    "double": "double", "bool": "bool", "char": "char",
}

def _c_params_for(norm):
    """C parameter TYPES an ONE logical param of normalised C++ type `norm` expands to."""
    if norm in _SCALAR_C:            return [_SCALAR_C[norm]]
    if norm == "string":             return ["char*"]
    if norm == "vector<int>":        return ["int*", "int"]
    if norm == "vector<longlong>" or norm == "vector<long>": return ["long long*", "int"]
    if norm == "vector<bool>":       return ["bool*", "int"]
    if norm == "vector<double>":     return ["double*", "int"]
    if norm == "vector<char>":       return ["char*", "int"]
    if norm == "vector<string>":     return ["char**", "int"]
    if norm == "vector<vector<int>>":  return ["int**", "int", "int*"]
    if norm == "vector<vector<char>>": return ["char**", "int", "int*"]
    if norm == "vector<vector<string>>": return ["char***", "int", "int*"]
    return None                       # unsupported

def _ret_c(norm):
    """(c_return_type, out_params_list) for a normalised C++ return type."""
    if norm in _SCALAR_C:            return _SCALAR_C[norm], []
    if norm == "string":             return "char*", []
    if norm == "vector<int>":        return "int*", ["int* returnSize"]
    if norm in ("vector<longlong>", "vector<long>"): return "long long*", ["int* returnSize"]
    if norm == "vector<bool>":       return "bool*", ["int* returnSize"]
    if norm == "vector<double>":     return "double*", ["int* returnSize"]
    if norm == "vector<char>":       return "char*", ["int* returnSize"]
    if norm == "vector<string>":     return "char**", ["int* returnSize"]
    if norm == "vector<vector<int>>":  return "int**", ["int* returnSize", "int** returnColumnSizes"]
    if norm == "vector<vector<char>>": return "char**", ["int* returnSize", "int** returnColumnSizes"]
    if norm == "vector<vector<string>>": return "char***", ["int* returnSize", "int** returnColumnSizes"]
    return None, None


def _norm_ret(ret):
    """Normalise a C++ return type (handles ListNode*/TreeNode* -> node)."""
    if "ListNode" in ret: return "ListNode*"
    if "TreeNode" in ret: return "TreeNode*"
    return cpp._norm(ret)


def analyze(slug):
    """Reuse the C++ analysis for the logical shape, then decide C supportability."""
    info = cpp.analyze(slug)
    if info["kind"] == "unsupported":
        return info
    if info["kind"] == "design":
        d = _design_info(slug)
        if d is None:
            return dict(kind="unsupported", method=info["method"],
                        reason="C: design method returns/params not handled")
        return dict(kind="design", method=info["method"], design=d)
    # normalise param types to a common list `norm`
    if info["kind"] == "plain":
        norm = list(info["ptypes"])
        retn = _norm_ret(info["ret"])
    else:                                   # tree / list
        norm = [_norm_ret(r) if ("TreeNode" in r or "ListNode" in r) else cpp._norm(r)
                for r in info["praw"]]
        retn = _norm_ret(info["ret"])
    # every param + the return must map to a C convention
    for n in norm:
        if n in ("TreeNode*", "ListNode*"):
            continue
        if _c_params_for(n) is None:
            return dict(kind="unsupported", method=info["method"],
                        reason="C: unhandled param type '%s'" % n)
    if retn not in ("TreeNode*", "ListNode*"):
        rt, _ = _ret_c(retn)
        if rt is None:
            return dict(kind="unsupported", method=info["method"],
                        reason="C: unhandled return type '%s'" % retn)
    return dict(kind=info["kind"], method=info["method"], ret=info["ret"],
                retn=retn, norm=norm)


# ── driver codegen ─────────────────────────────────────────────────────────────
def _extern_decl(method, norm, retn, node_ret):
    """The `extern "C"` declaration matching the model's LeetCode signature."""
    ptypes = []
    for n in norm:
        if n == "TreeNode*": ptypes.append("struct TreeNode*")
        elif n == "ListNode*": ptypes.append("struct ListNode*")
        else: ptypes.extend(_c_params_for(n))
    if node_ret:
        cret = "struct %s*" % ("TreeNode" if retn == "TreeNode*" else "ListNode")
        outs = []
    else:
        cret, outs = _ret_c(retn)
    ptypes.extend(outs)
    return 'extern "C" %s %s(%s);' % (cret, method, ", ".join(ptypes) if ptypes else "void")


def _marshal_args(norm, indent, srcexpr=None):
    """Emit (decl_lines, call_arg_names) marshalling JSON -> C args. Keep-alive
    C++ containers live in the enclosing scope so their .data() stays valid.
    `srcexpr(i)` gives the JSON-source expression for arg i (default: the
    plain-call `E[i].second`; design uses `ARG[0].arr[i]` / `aa.arr[i]`)."""
    if srcexpr is None:
        srcexpr = lambda i: "E[%d].second" % i
    lines, args = [], []
    for i, n in enumerate(norm):
        src = srcexpr(i)
        if n in _SCALAR_C:
            fn = {"int": "to_int", "long": "to_ll", "longlong": "to_ll",
                  "double": "to_double", "bool": "to_bool", "char": "to_char"}[n]
            lines.append("%sauto a%d = hz::%s(%s);" % (indent, i, fn, src)); args.append("a%d" % i)
        elif n == "string":
            lines.append("%sstd::string s%d = hz::to_str(%s); char* a%d = const_cast<char*>(s%d.c_str());" % (indent, i, src, i, i))
            args.append("a%d" % i)
        elif n in ("vector<int>", "vector<longlong>", "vector<long>", "vector<double>", "vector<char>"):
            fn = {"vector<int>": "to_vint", "vector<longlong>": "to_vll", "vector<long>": "to_vll",
                  "vector<double>": "to_vdouble", "vector<char>": "to_vchar"}[n]
            elem = {"vector<int>": "int", "vector<longlong>": "long long", "vector<long>": "long long",
                    "vector<double>": "double", "vector<char>": "char"}[n]
            lines.append("%sstd::vector<%s> v%d = hz::%s(%s); %s* a%d = v%d.data(); int a%dn = (int)v%d.size();" % (indent, elem, i, fn, src, elem, i, i, i, i))
            args.append("a%d, a%dn" % (i, i))
        elif n == "vector<bool>":
            lines.append("%sstd::vector<int> t%d = hz::to_vint(%s); std::vector<unsigned char> v%d(t%d.begin(), t%d.end()); bool* a%d = (bool*)v%d.data(); int a%dn = (int)v%d.size();" % (indent, i, src, i, i, i, i, i, i, i))
            args.append("a%d, a%dn" % (i, i))
        elif n == "vector<string>":
            lines.append("%sstd::vector<std::string> vs%d = hz::to_vstr(%s); std::vector<char*> cp%d; for (auto& _s : vs%d) cp%d.push_back(const_cast<char*>(_s.c_str())); char** a%d = cp%d.data(); int a%dn = (int)vs%d.size();" % (indent, i, src, i, i, i, i, i, i, i))
            args.append("a%d, a%dn" % (i, i))
        elif n in ("vector<vector<int>>", "vector<vector<char>>"):
            fn = "to_vvint" if n == "vector<vector<int>>" else "to_vvchar"
            elem = "int" if n == "vector<vector<int>>" else "char"
            lines.append("%sstd::vector<std::vector<%s>> vv%d = hz::%s(%s); std::vector<%s*> rp%d; std::vector<int> cz%d; for (auto& _r : vv%d) { rp%d.push_back(_r.data()); cz%d.push_back((int)_r.size()); } %s** a%d = rp%d.data(); int a%dn = (int)vv%d.size(); int* a%dc = cz%d.data();" % (indent, elem, i, fn, src, elem, i, i, i, i, i, elem, i, i, i, i, i, i))
            args.append("a%d, a%dn, a%dc" % (i, i, i))
        elif n == "vector<vector<string>>":
            lines.append("%sstd::vector<std::vector<std::string>> vv%d = hz::to_vvstr(%s); std::vector<std::vector<char*>> cc%d(vv%d.size()); std::vector<char**> rp%d; std::vector<int> cz%d; for (size_t _r = 0; _r < vv%d.size(); _r++) { for (auto& _s : vv%d[_r]) cc%d[_r].push_back(const_cast<char*>(_s.c_str())); rp%d.push_back(cc%d[_r].data()); cz%d.push_back((int)vv%d[_r].size()); } char*** a%d = rp%d.data(); int a%dn = (int)vv%d.size(); int* a%dc = cz%d.data();" % (indent, i, src, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i))
            args.append("a%d, a%dn, a%dc" % (i, i, i))
        elif n == "TreeNode*":
            lines.append("%sTreeNode* a%d = hz::to_tree(%s);" % (indent, i, src)); args.append("a%d" % i)
        elif n == "ListNode*":
            lines.append("%sListNode* a%d = hz::to_list(%s);" % (indent, i, src)); args.append("a%d" % i)
        else:
            raise ValueError("unhandled C param type %s" % n)
    return lines, args


def _marshal_return(retn, node_ret, method, callargs, indent, dest="actual"):
    """Emit lines that call `method(callargs...)` and set `std::string <dest>`."""
    L = []
    if node_ret:
        L.append("%s%s* _r = %s(%s);" % (indent, "ListNode" if retn == "ListNode*" else "TreeNode", method, ", ".join(callargs)))
        if retn == "ListNode*":
            L.append("%sstd::vector<int> _rv = hz::listVals(_r);" % indent)
        else:
            L.append("%sstd::vector<int> _rv = hz::treeVals_level(_r);" % indent)
        L.append("%s%s = hz::canon(_rv);" % (indent, dest))
        return L
    cret, outs = _ret_c(retn)
    call_extra = []
    if outs:                       # returnSize (+ returnColumnSizes)
        L.append("%sint _rsz = 0;" % indent); call_extra.append("&_rsz")
        if len(outs) == 2:
            L.append("%sint* _rcol = nullptr;" % indent); call_extra.append("&_rcol")
    allargs = ", ".join(list(callargs) + call_extra)
    if retn in _SCALAR_C:
        L.append("%sauto _r = %s(%s);" % (indent, method, allargs))
        L.append("%s%s = hz::canon(_r);" % (indent, dest))
    elif retn == "string":
        L.append("%schar* _r = %s(%s); std::string _rs = _r ? std::string(_r) : std::string();" % (indent, method, allargs))
        L.append("%s%s = hz::canon(_rs);" % (indent, dest))
    elif retn in ("vector<int>", "vector<longlong>", "vector<long>"):
        L.append("%slong long* _dummy = nullptr; (void)_dummy;" % indent) if False else None
        elem = "long long" if retn != "vector<int>" else "int"
        L.append("%s%s* _r = %s(%s);" % (indent, elem, method, allargs))
        L.append("%sstd::vector<%s> _rv(_r, _r + _rsz);" % (indent, elem))
        L.append("%s%s = hz::canon(_rv);" % (indent, dest))
    elif retn == "vector<double>":
        L.append("%sdouble* _r = %s(%s);" % (indent, method, allargs))
        L.append("%sstd::vector<double> _rv(_r, _r + _rsz);" % indent)
        L.append("%s%s = hz::canon(_rv);" % (indent, dest))
    elif retn == "vector<char>":
        L.append("%schar* _r = %s(%s);" % (indent, method, allargs))
        L.append("%sstd::vector<char> _rv(_r, _r + _rsz);" % indent)
        L.append("%s%s = hz::canon(_rv);" % (indent, dest))
    elif retn == "vector<bool>":
        L.append("%sbool* _r = %s(%s);" % (indent, method, allargs))
        L.append("%sstd::vector<bool> _rv; for (int _k = 0; _k < _rsz; _k++) _rv.push_back(_r[_k]);" % indent)
        L.append("%s%s = hz::canon(_rv);" % (indent, dest))
    elif retn == "vector<string>":
        L.append("%schar** _r = %s(%s);" % (indent, method, allargs))
        L.append("%sstd::vector<std::string> _rv; for (int _k = 0; _k < _rsz; _k++) _rv.push_back(_r[_k] ? std::string(_r[_k]) : std::string());" % indent)
        L.append("%s%s = hz::canon(_rv);" % (indent, dest))
    elif retn in ("vector<vector<int>>", "vector<vector<char>>"):
        elem = "int" if retn == "vector<vector<int>>" else "char"
        L.append("%s%s** _r = %s(%s);" % (indent, elem, method, allargs))
        L.append("%sstd::vector<std::vector<%s>> _rv; for (int _k = 0; _k < _rsz; _k++) { std::vector<%s> _row(_r[_k], _r[_k] + _rcol[_k]); _rv.push_back(_row); }" % (indent, elem, elem))
        L.append("%s%s = hz::canon(_rv);" % (indent, dest))
    elif retn == "vector<vector<string>>":
        L.append("%schar*** _r = %s(%s);" % (indent, method, allargs))
        L.append("%sstd::vector<std::vector<std::string>> _rv; for (int _k = 0; _k < _rsz; _k++) { std::vector<std::string> _row; for (int _j = 0; _j < _rcol[_k]; _j++) _row.push_back(_r[_k][_j] ? std::string(_r[_k][_j]) : std::string()); _rv.push_back(_row); }" % indent)
        L.append("%s%s = hz::canon(_rv);" % (indent, dest))
    else:
        raise ValueError("unhandled C return type %s" % retn)
    return L


# ── design: naming + info + externs ────────────────────────────────────────────
def _lcfirst(s): return s[:1].lower() + s[1:]
def _ucfirst(s): return s[:1].upper() + s[1:]
def _cfn(className, op): return _lcfirst(className) + _ucfirst(op)   # customStackPush

def _design_info(slug):
    """(className, ctor_norm_types, methods) or None if unsupported.
    methods = [(op, retn, [norm param types])]; retn in _SCALAR_C or 'void'."""
    sol = os.path.join(ROOT, "C++", "leetcode", slug, "solution.cpp")
    src = open(sol).read()
    cases = json.load(open(os.path.join(REF, "outputs", slug + ".json")))["expected"]
    className = cases[0]["input"]["ops"][0]
    if cpp._defines_struct(src, className):
        ctor_params = cpp._sig_params(src, className) or ""
    else:                                    # class Solution with a ctor-style first op
        _r, ctor_params = cpp._method_sig(src, className)
        if ctor_params is None:
            ctor_params = cpp._sig_params(src, className) or ""
    cnorm = [cpp._norm(cpp._param_type(x)) for x in cpp._split_params(ctor_params)] if ctor_params.strip() else []
    names, seen = [], set()
    for c in cases:
        for o in c["input"]["ops"][1:]:
            if o not in seen: seen.add(o); names.append(o)
    methods = []
    for name in names:
        ret, params = cpp._method_sig(src, name)
        if params is None: params = cpp._sig_params(src, name) or ""
        retn = "void" if (ret is not None and ret.strip() == "void") else cpp._norm(ret or "")
        mnorm = [cpp._norm(cpp._param_type(x)) for x in cpp._split_params(params)] if params.strip() else []
        if retn != "void" and retn not in _SCALAR_C:
            return None                       # array-returning design method: unsupported
        for t in cnorm + mnorm:
            if _c_params_for(t) is None:
                return None                   # unhandled ctor/method param type
        methods.append((name, retn, mnorm))
    return className, cnorm, methods


def _c_types(norm_list):
    out = []
    for n in norm_list:
        out.extend(_c_params_for(n))
    return out


def _design_externs(className, cnorm, methods):
    lines = ['extern "C" void* %sCreate(%s);' % (_lcfirst(className),
                                                  ", ".join(_c_types(cnorm)) or "void")]
    for op, retn, mnorm in methods:
        cret = "void" if retn == "void" else _SCALAR_C[retn]
        params = ["void*"] + _c_types(mnorm)
        lines.append('extern "C" %s %s(%s);' % (cret, _cfn(className, op), ", ".join(params)))
    lines.append('extern "C" void %sFree(void*);' % _lcfirst(className))
    return "\n".join(lines) + "\n"


def _c_prelude(info):
    if info["kind"] == "design":
        className, cnorm, methods = info["design"]
        uses_tree = uses_list = False
        for _op, _r, mn in methods:
            uses_tree = uses_tree or "TreeNode*" in mn
            uses_list = uses_list or "ListNode*" in mn
        pre = (C_NODES if (uses_tree or uses_list) else "") + _design_externs(className, cnorm, methods)
        hz_extra = (HZ_TREE_C if uses_tree else "") + (HZ_LIST_C if uses_list else "")
        body = (cpp.PRELUDE.replace("__PRE_INCLUDE__", pre).replace("__HZ_EXTRA__", hz_extra))
        return body.replace('#include "__SOLUTION__"      // provides: class Solution (and, for some cells, TreeNode/ListNode)', "")
    node_ret = info["retn"] in ("TreeNode*", "ListNode*")
    uses_tree = "TreeNode*" in info["norm"] or info["retn"] == "TreeNode*"
    uses_list = "ListNode*" in info["norm"] or info["retn"] == "ListNode*"
    pre = C_NODES if (uses_tree or uses_list) else ""
    pre += _extern_decl(info["method"], info["norm"], info["retn"], node_ret)
    hz_extra = (HZ_TREE_C if uses_tree else "") + (HZ_LIST_C if uses_list else "")
    # reuse the C++ prelude, but DROP the `#include "solution"` (solution is C, linked).
    body = (cpp.PRELUDE
            .replace("__PRE_INCLUDE__", pre)
            .replace("__HZ_EXTRA__", hz_extra))
    body = body.replace('#include "__SOLUTION__"      // provides: class Solution (and, for some cells, TreeNode/ListNode)', "")
    return body


def gen_validate(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    node_ret = info["retn"] in ("TreeNode*", "ListNode*")
    decls, args = _marshal_args(info["norm"], " " * 12)
    ret_lines = _marshal_return(info["retn"], node_ret, info["method"], args, " " * 12)
    unordered = slug in _UNORDERED
    exp_expr = "canonJVal_multiset(*outV)" if unordered else "canonJVal(*outV)"
    if unordered:                # re-canon `actual` as a multiset for special-judge
        ret_lines.append("            { hz::JVal _pa = hz::JP(actual).val(); actual = canonJVal_multiset(_pa); }")
    body = "\n".join(decls + ret_lines)
    return (_c_prelude(info)
            + cpp.MAIN_VALIDATE_PLAIN.replace("__OUTPUTS__", outs)
                                     .replace("__SLUG__", slug)
                                     .replace("__EXP_EXPR__", exp_expr)
                                     .replace("__BUILD_INLINE__", body))


# ── perf-measure driver ────────────────────────────────────────────────────────
# As in the C++ driver: the inputs are parsed from JSON once, before timing, and
# every call gets a fresh native copy (a solution may change its input). The call
# returns its result as the C++ type of the logical signature, so MAIN_PLAIN folds
# it with hz::cs exactly as it folds a C++ result. After the call, the driver
# frees what LeetCode's contract says the caller frees (the returned arrays), but
# never memory that is one of the call's own inputs (e.g. `return nums;`), and the
# input trees and lists, as the C++ driver does. A returned string array keeps its
# strings, which a solution often takes from its input.
_SCALAR_FN = {"int": "to_int", "long": "to_ll", "longlong": "to_ll",
              "double": "to_double", "bool": "to_bool", "char": "to_char"}
_VEC_ELEM = {"vector<int>": ("to_vint", "int"), "vector<longlong>": ("to_vll", "long long"),
             "vector<long>": ("to_vll", "long long"), "vector<double>": ("to_vdouble", "double"),
             "vector<char>": ("to_vchar", "char")}


def _measure_inputs(norm):
    """(base, call, args, ins, frees): `base` parses each input once, before
    timing; `call` makes the per-call copy and the C pointers into it; `ins`
    names the input pointers (never freed); `frees` frees the input nodes."""
    base, call, args, ins, frees = [], [], [], [], []
    for i, n in enumerate(norm):
        src = "E[%d].second" % i
        if n in _SCALAR_FN:
            base.append("    auto base%d = hz::%s(%s);" % (i, _SCALAR_FN[n], src))
            call.append("        auto a%d = base%d;" % (i, i))
            args.append("a%d" % i)
        elif n == "string":
            base.append("    std::string base%d = hz::to_str(%s);" % (i, src))
            call.append("        std::string s{i} = base{i}; hz::opaque(s{i}); char* a{i} = s{i}.data();".format(i=i))
            args.append("a%d" % i); ins.append("a%d" % i)
        elif n in _VEC_ELEM:
            fn, elem = _VEC_ELEM[n]
            base.append("    std::vector<%s> base%d = hz::%s(%s);" % (elem, i, fn, src))
            call.append("        std::vector<{e}> v{i} = base{i}; hz::opaque(v{i}); {e}* a{i} = v{i}.data(); "
                        "int a{i}n = (int)v{i}.size();".format(e=elem, i=i))
            args.append("a{i}, a{i}n".format(i=i)); ins.append("a%d" % i)
        elif n == "vector<bool>":
            base.append("    std::vector<int> t{i} = hz::to_vint({s}); "
                        "std::vector<unsigned char> base{i}(t{i}.begin(), t{i}.end());".format(i=i, s=src))
            call.append("        std::vector<unsigned char> v{i} = base{i}; hz::opaque(v{i}); "
                        "bool* a{i} = (bool*)v{i}.data(); int a{i}n = (int)v{i}.size();".format(i=i))
            args.append("a{i}, a{i}n".format(i=i)); ins.append("a%d" % i)
        elif n == "vector<string>":
            base.append("    std::vector<std::string> base%d = hz::to_vstr(%s);" % (i, src))
            call.append("        std::vector<std::string> vs{i} = base{i}; hz::opaque(vs{i}); std::vector<char*> cp{i}; "
                        "for (auto& _s : vs{i}) cp{i}.push_back(_s.data()); char** a{i} = cp{i}.data(); "
                        "int a{i}n = (int)vs{i}.size();".format(i=i))
            args.append("a{i}, a{i}n".format(i=i)); ins.append("a%d" % i)
        elif n in ("vector<vector<int>>", "vector<vector<char>>"):
            fn, elem = ("to_vvint", "int") if n == "vector<vector<int>>" else ("to_vvchar", "char")
            base.append("    std::vector<std::vector<%s>> base%d = hz::%s(%s);" % (elem, i, fn, src))
            call.append("        std::vector<std::vector<{e}>> vv{i} = base{i}; hz::opaque(vv{i}); std::vector<{e}*> rp{i}; "
                        "std::vector<int> cz{i}; for (auto& _r : vv{i}) {{ rp{i}.push_back(_r.data()); "
                        "cz{i}.push_back((int)_r.size()); }} {e}** a{i} = rp{i}.data(); int a{i}n = (int)vv{i}.size(); "
                        "int* a{i}c = cz{i}.data();".format(e=elem, i=i))
            args.append("a{i}, a{i}n, a{i}c".format(i=i)); ins += ["a%d" % i, "a%dc" % i]
        elif n == "vector<vector<string>>":
            base.append("    std::vector<std::vector<std::string>> base%d = hz::to_vvstr(%s);" % (i, src))
            call.append("        std::vector<std::vector<std::string>> vv{i} = base{i}; hz::opaque(vv{i}); "
                        "std::vector<std::vector<char*>> cc{i}(vv{i}.size()); std::vector<char**> rp{i}; "
                        "std::vector<int> cz{i}; for (size_t _r = 0; _r < vv{i}.size(); _r++) {{ "
                        "for (auto& _s : vv{i}[_r]) cc{i}[_r].push_back(_s.data()); rp{i}.push_back(cc{i}[_r].data()); "
                        "cz{i}.push_back((int)vv{i}[_r].size()); }} char*** a{i} = rp{i}.data(); "
                        "int a{i}n = (int)vv{i}.size(); int* a{i}c = cz{i}.data();".format(i=i))
            args.append("a{i}, a{i}n, a{i}c".format(i=i)); ins += ["a%d" % i, "a%dc" % i]
        elif n in ("TreeNode*", "ListNode*"):
            fn, free_fn = ("to_tree", "freeTree") if n == "TreeNode*" else ("to_list", "freeList")
            call.append("        %s a%d = hz::%s(%s); hz::opaque(a%d);" % (n, i, fn, src, i))
            args.append("a%d" % i); frees.append("        hz::%s(a%d);" % (free_fn, i))
        else:
            raise ValueError("unhandled C param type %s" % n)
    return base, call, args, ins, frees


def _measure_result(retn, node_ret, method, args, ins, frees):
    """Lines that call the solution, convert its result to the logical C++
    type, free per LeetCode's contract, and return the converted result."""
    def free_out(p):        # free p unless it is null or one of the inputs
        keep = "".join(" && (const void*)%s != (const void*)%s" % (p, x) for x in ins)
        return "        if (%s%s) free(%s);" % (p, keep, p)
    L = []
    if node_ret:
        node = "ListNode" if retn == "ListNode*" else "TreeNode"
        vals = "listVals" if node == "ListNode" else "treeVals_level"
        L.append("        %s* _r = %s(%s);" % (node, method, ", ".join(args)))
        L.append("        std::vector<int> _rv = hz::%s(_r);" % vals)
        return L + frees + ["        return _rv;"]
    cret, outs = _ret_c(retn)
    extra = []
    if outs:
        L.append("        int _rsz = 0;"); extra.append("&_rsz")
        if len(outs) == 2:
            L.append("        int* _rcol = nullptr;"); extra.append("&_rcol")
    call = "%s(%s)" % (method, ", ".join(list(args) + extra))
    if retn in _SCALAR_C:
        L.append("        auto _rv = %s;" % call)
    elif retn == "string":
        L.append("        char* _r = %s; std::string _rv = _r ? std::string(_r) : std::string();" % call)
        L.append(free_out("_r"))
    elif retn in _VEC_ELEM:
        elem = _VEC_ELEM[retn][1]
        L.append("        %s* _r = %s; std::vector<%s> _rv(_r, _r + _rsz);" % (elem, call, elem))
        L.append(free_out("_r"))
    elif retn == "vector<bool>":
        L.append("        bool* _r = %s; std::vector<bool> _rv(_r, _r + _rsz);" % call)
        L.append(free_out("_r"))
    elif retn == "vector<string>":
        L.append("        char** _r = %s; std::vector<std::string> _rv; for (int _k = 0; _k < _rsz; _k++) "
                 "_rv.push_back(_r[_k] ? std::string(_r[_k]) : std::string());" % call)
        L.append(free_out("_r"))
    elif retn in ("vector<vector<int>>", "vector<vector<char>>"):
        elem = "int" if retn == "vector<vector<int>>" else "char"
        L.append("        {e}** _r = {c}; std::vector<std::vector<{e}>> _rv; for (int _k = 0; _k < _rsz; _k++) "
                 "_rv.emplace_back(_r[_k], _r[_k] + _rcol[_k]);".format(e=elem, c=call))
        keep = "".join(" && (const void*)_r != (const void*)%s" % x for x in ins)
        L.append("        if (_r%s) { for (int _k = 0; _k < _rsz; _k++) free(_r[_k]); free(_r); }" % keep)
        L.append(free_out("_rcol"))
    elif retn == "vector<vector<string>>":
        L.append("        char*** _r = %s; std::vector<std::vector<std::string>> _rv; for (int _k = 0; _k < _rsz; _k++) "
                 "{ std::vector<std::string> _row; for (int _j = 0; _j < _rcol[_k]; _j++) "
                 "_row.push_back(_r[_k][_j] ? std::string(_r[_k][_j]) : std::string()); _rv.push_back(_row); }" % call)
        keep = "".join(" && (const void*)_r != (const void*)%s" % x for x in ins)
        L.append("        if (_r%s) { for (int _k = 0; _k < _rsz; _k++) free(_r[_k]); free(_r); }" % keep)
        L.append(free_out("_rcol"))
    else:
        raise ValueError("unhandled C return type %s" % retn)
    return L + frees + ["        return _rv;"]


def gen_measure(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    node_ret = info["retn"] in ("TreeNode*", "ListNode*")
    base, call, args, ins, frees = _measure_inputs(info["norm"])
    body = base + ["", "    auto do_call = [&]() {"] + call
    body += _measure_result(info["retn"], node_ret, info["method"], args, ins, frees)
    body.append("    };")
    main = cpp.MAIN_PLAIN.replace("__OUTPUTS__", outs).replace("__BUILD_ARGS__", "\n".join(body))
    return _c_prelude(info) + main


# ── design driver codegen ──────────────────────────────────────────────────────
def _design_construct(className, cnorm):
    decls, cargs = _marshal_args(cnorm, " " * 12, srcexpr=lambda i: "ARG[0].arr[%d]" % i)
    L = ["        void* obj = nullptr;", "        {"] + decls
    L.append("            obj = %sCreate(%s);" % (_lcfirst(className), ", ".join(cargs)))
    L.append("        }")
    L.append('        if (results) results->push_back("null");')
    return "\n".join(L)


def _design_dispatch(className, methods):
    branches = []
    for n_i, (op, retn, mnorm) in enumerate(methods):
        decls, margs = _marshal_args(mnorm, " " * 16, srcexpr=lambda i: "aa.arr[%d]" % i)
        callargs = ", ".join(["obj"] + margs)
        b = ['            %s (op == "%s") {' % ("if" if n_i == 0 else "else if", op)] + decls
        if retn == "void":
            b.append("                %s(%s);" % (_cfn(className, op), callargs))
            b.append("                h = h * 1000003 + 3;")
            b.append('                if (results) results->push_back("null");')
        else:
            b.append("                auto rv = %s(%s);" % (_cfn(className, op), callargs))
            b.append("                h = h * 1000003 + hz::cs(rv);")
            b.append("                if (results) results->push_back(hz::canon(rv));")
        b.append("            }")
        branches.append("\n".join(b))
    return "\n".join(branches)


def gen_validate_design(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    className, cnorm, methods = info["design"]
    randomized = "true" if slug == "random-pick-index" else "false"
    return (_c_prelude(info)
            + cpp.MAIN_VALIDATE_DESIGN.replace("__OUTPUTS__", outs)
                                      .replace("__SLUG__", slug)
                                      .replace("__RANDOMIZED__", randomized)
                                      .replace("__CONSTRUCT__", _design_construct(className, cnorm))
                                      .replace("__DISPATCH__", _design_dispatch(className, methods)))


def gen_measure_design(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    className, cnorm, methods = info["design"]
    main = (cpp.MAIN_DESIGN.replace("__OUTPUTS__", outs)
            .replace("__CONSTRUCT__", _design_construct(className, cnorm))
            .replace("__DISPATCH__", _design_dispatch(className, methods))
            .replace("        return h;\n    };",
                     "        %sFree(obj);\n        return h;\n    };" % _lcfirst(className)))
    return _c_prelude(info) + main


# ── compile (gcc solution.o + g++ driver) & run ────────────────────────────────
def _compile_solution_o(slug, info, tmp):
    """gcc-compile the cell's solution.c -> solution.o, injecting node structs
    if the model didn't define them. Returns (obj_path, err_or_None)."""
    cell = os.path.join(ROOT, "C", "leetcode", slug)
    src = open(os.path.join(cell, "solution.c")).read()
    import re as _re
    # LeetCode C solutions never define main(); a model-added one (test
    # scaffolding) collides with the harness driver's main. Strip a top-level
    # `int main(...) { ... }` via brace matching.
    mm = _re.search(r'\b(?:int|void)\s+main\s*\([^)]*\)\s*\{', src)
    if mm:
        depth, j = 0, mm.end() - 1
        while j < len(src):
            if src[j] == '{': depth += 1
            elif src[j] == '}':
                depth -= 1
                if depth == 0: break
            j += 1
        src = src[:mm.start()] + src[j + 1:]
    def _defines(name):                    # a DEFINITION `struct X {`, not a reference
        # Strip comments first: models reproduce LeetCode's header comment,
        # which contains the struct definition INSIDE /** ... */ — matching
        # it there skips the injection and the build dies with
        # "incomplete definition of type 'struct X'".
        src_nc = _re.sub(r'/\*.*?\*/', '', src, flags=_re.S)
        src_nc = _re.sub(r'//[^\n]*', '', src_nc)
        return _re.search(r'struct\s+' + name + r'\s*\{', src_nc) is not None
    if info["kind"] == "design":           # any node type across ctor/method params
        allt = list(info["design"][1]) + [t for _o, _r, mn in info["design"][2] for t in mn]
    else:
        allt = list(info["norm"]) + [info["retn"]]
    uses_tree = "TreeNode*" in allt
    uses_list = "ListNode*" in allt
    inject = ""
    if uses_tree and not _defines("TreeNode"):
        inject += "struct TreeNode { int val; struct TreeNode *left; struct TreeNode *right; };\n"
    if uses_list and not _defines("ListNode"):
        inject += "struct ListNode { int val; struct ListNode *next; };\n"
    cpath = os.path.join(tmp, "solution.c")
    open(cpath, "w").write(C_STD_PRELUDE + inject + src)
    obj = os.path.join(tmp, "solution.o")
    cc = subprocess.run(["gcc", *cpp.compile_flags(["-O2", "-std=c11", "-w"]), "-c", cpath, "-o", obj],
                        capture_output=True, text=True)
    if cc.returncode != 0:
        lines = cc.stderr.strip().splitlines() if cc.stderr else []
        err = next((l for l in lines if "error:" in l), lines[-1] if lines else "gcc failed")
        return None, err
    return obj, None


def _build(slug, mode):
    info = analyze(slug)
    if info["kind"] == "unsupported":
        return None, info, info.get("reason", "unsupported")
    tmp = tempfile.mkdtemp(prefix="hz_c_%s_" % mode)
    obj, err = _compile_solution_o(slug, info, tmp)
    if obj is None:
        return None, info, "solution.c: " + err
    if info["kind"] == "design":
        src = gen_validate_design(slug, info) if mode == "validate" else gen_measure_design(slug, info)
    else:
        src = gen_validate(slug, info) if mode == "validate" else gen_measure(slug, info)
    cpp_path = os.path.join(tmp, "driver.cpp"); binp = os.path.join(tmp, "driver")
    open(cpp_path, "w").write(src)
    cc = subprocess.run(["g++", *cpp.compile_flags(["-O2", "-std=c++17"]), cpp_path, obj, "-o", binp],
                        capture_output=True, text=True)
    if cc.returncode != 0:
        return None, info, "driver link: " + (cc.stderr.strip().splitlines()[-1] if cc.stderr else "")
    return binp, info, tmp


def build_and_validate(slug, keep=False):
    binp, info, tmp = _build(slug, "validate")
    if binp is None:
        sys.stderr.write("VALIDATE slug=%s ERROR %s\n" % (slug, tmp))
        return 2
    celldir = os.path.join(ROOT, "C", "leetcode", slug)
    rr = subprocess.run([binp], capture_output=True, text=True, cwd=celldir, timeout=300)
    if rr.stderr:
        sys.stderr.write(rr.stderr)
    return rr.returncode


def build_and_run(slug, budget, idx):
    binp, info, tmp = _build(slug, "measure")
    if binp is None:
        return "compile_error", tmp, None
    celldir = os.path.join(ROOT, "C", "leetcode", slug)
    rr = subprocess.run([binp, str(budget), str(idx)], capture_output=True, text=True,
                        cwd=celldir, timeout=max(30, budget * 4 + 20))
    if rr.returncode != 0:
        return "runtime_error", (rr.stderr.strip().splitlines()[-1] if rr.stderr else "rc=%d" % rr.returncode), None
    return "ok", rr.stderr.strip(), None


def main():
    if len(sys.argv) > 1 and sys.argv[1] == "validate":
        slug = os.path.basename(os.getcwd())
        sys.exit(build_and_validate(slug))
    if len(sys.argv) > 1 and sys.argv[1] == "build":
        # Prebuild the driver into <cell>/.perf_build/driver for run_harness.sh
        # run mode, so a measured run never includes the compilers.
        slug = os.path.basename(os.getcwd())
        binp, _info, tmp = _build(slug, "measure")
        if binp is None:
            print("TODO/compile_error %s: %s" % (slug, tmp), file=sys.stderr)
            sys.exit(1)
        out = os.path.join(os.getcwd(), ".perf_build")
        os.makedirs(out, exist_ok=True)
        for f in ("driver", "driver.cpp"):
            # copy, then rename: overwriting an executable in place makes macOS
            # kill its next start (SIGKILL); a rename gives a new file
            shutil.copy(os.path.join(tmp, f), os.path.join(out, f + ".new"))
            os.replace(os.path.join(out, f + ".new"), os.path.join(out, f))
        sys.exit(0)
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
