#!/usr/bin/env python3
"""Dart full-suite validator + perf harness for the leetcode cells.

Dart runs on the Dart VM (`dart run`, JIT), so — like harness_swift / harness_scala
— this is a codegen harness: it reuses harness_cpp.analyze() for the logical
shape, maps each C++ type to the deterministic LeetCode-Dart type, and emits a
Dart driver that parses the shared JSON cases (via dart:convert), marshals them
into typed Dart values, calls `Solution().method(...)` / `Name(...)`, canonicalises
the result in the SAME textual form as the C++/Swift/Scala harnesses, and compares
to the expected output.

LeetCode Dart shape:
  * `class Solution { R method(T a, ...) { } }`  (normal param labels)
  * design: `class Name { Name(ctor...); R op(...) { } }`  (Name(...) constructor)
  * nodes: `class TreeNode { int val; TreeNode? left; TreeNode? right; ... }`,
           `class ListNode { int val; ListNode? next; ... }`

Build layout (a temp dir): nodes.dart + solution.dart (the cell's, with a node
import prepended) + main.dart (the generated driver). `dart run main.dart` compiles
and runs in one step, so the solution keeps its own imports valid.

Contract (run FROM the cell dir):
    python3 harness_dart.py validate      -> exit 0/1/3 (Accepted/WA/RE), 2 compile
                                             error or setup
    python3 harness_dart.py check         -> the cell Makefile's compile check: the
                                             validation driver compiled (dart compile
                                             kernel) in a temp dir; runs nothing
    python3 harness_dart.py build         -> the measure driver compiled ONCE, ahead
                                             of time (dart compile exe, as the Dart
                                             CLBG cells), to .perf_build/driver;
                                             run_harness.sh run mode only starts it
    python3 harness_dart.py <budget> <idx> -> perf line on stderr (build + run in one
                                             step; no measurement uses it)
"""
import json, os, re, shutil, subprocess, sys, tempfile
import harness_cpp as cpp

ROOT = cpp.ROOT
REF  = cpp.REF
_UNORDERED = cpp._UNORDERED
DART = os.environ.get("DART", "dart")

_SCALAR = {"int": "int", "long": "int", "longlong": "int",
           "double": "double", "bool": "bool", "char": "String"}
_SCALAR_MARSHAL = {"int": "_toInt", "long": "_toInt", "longlong": "_toInt",
                   "double": "_toDbl", "bool": "_toBool", "char": "_toChar"}
_ARR = {
    "vector<int>": ("List<int>", "_toIntArr"), "vector<longlong>": ("List<int>", "_toIntArr"),
    "vector<long>": ("List<int>", "_toIntArr"), "vector<double>": ("List<double>", "_toDblArr"),
    "vector<bool>": ("List<bool>", "_toBoolArr"), "vector<char>": ("List<String>", "_toCharArr"),
    "vector<string>": ("List<String>", "_toStrArr"),
    "vector<vector<int>>": ("List<List<int>>", "_toIntArr2"),
    "vector<vector<double>>": ("List<List<double>>", "_toDblArr2"),
    "vector<vector<char>>": ("List<List<String>>", "_toCharArr2"),
    "vector<vector<string>>": ("List<List<String>>", "_toStrArr2"),
}


def _dart_type(norm):
    if norm in _SCALAR: return _SCALAR[norm]
    if norm == "string": return "String"
    if norm in _ARR: return _ARR[norm][0]
    if norm == "TreeNode*": return "TreeNode?"
    if norm == "ListNode*": return "ListNode?"
    return None


def _norm_ret(ret):
    if "ListNode" in ret: return "ListNode*"
    if "TreeNode" in ret: return "TreeNode*"
    return cpp._norm(ret)


def analyze(slug):
    info = cpp.analyze(slug)
    if info["kind"] == "unsupported":
        return info
    if info["kind"] == "design":
        d = _design_info(slug)
        if d is None:
            return dict(kind="unsupported", method=info["method"],
                        reason="Dart: design method returns/params not handled")
        return dict(kind="design", method=info["method"], design=d)
    if info["kind"] == "plain":
        norm = list(info["ptypes"]); retn = _norm_ret(info["ret"])
    else:
        norm = [_norm_ret(r) if ("TreeNode" in r or "ListNode" in r) else cpp._norm(r)
                for r in info["praw"]]
        retn = _norm_ret(info["ret"])
    for n in norm:
        if _dart_type(n) is None:
            return dict(kind="unsupported", method=info["method"],
                        reason="Dart: unhandled param type '%s'" % n)
    if _dart_type(retn) is None:
        return dict(kind="unsupported", method=info["method"],
                    reason="Dart: unhandled return type '%s'" % retn)
    return dict(kind=info["kind"], method=info["method"], ret=info["ret"],
                retn=retn, norm=norm)


# ── design ─────────────────────────────────────────────────────────────────────
def _design_info(slug):
    sol = os.path.join(ROOT, "C++", "leetcode", slug, "solution.cpp")
    if not os.path.exists(sol):
        src = cpp._cpp_stub_from_starter(slug, None) if hasattr(cpp, "_cpp_stub_from_starter") else None
        if not src:
            return None
    else:
        src = open(sol).read()
    cases = json.load(open(os.path.join(REF, "outputs", slug + ".json")))["expected"]
    className = cases[0]["input"]["ops"][0]
    if cpp._defines_struct(src, className):
        ctor_params = cpp._sig_params(src, className) or ""
    else:
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
        if retn != "void" and _dart_type(retn) is None:
            return None
        for t in cnorm + mnorm:
            if _dart_type(t) is None:
                return None
        methods.append((name, retn, mnorm))
    return className, cnorm, methods


# ── Dart driver pieces: nodes + marshal + canon ────────────────────────────────
NODES = """\
class TreeNode {
  int val;
  TreeNode? left;
  TreeNode? right;
  TreeNode([this.val = 0, this.left, this.right]);
}

class ListNode {
  int val;
  ListNode? next;
  ListNode([this.val = 0, this.next]);
}
"""

PRELUDE = r"""
int _toInt(dynamic v) => v is int ? v : (v is bool ? (v ? 1 : 0) : (v as num).toInt());
double _toDbl(dynamic v) => v is num ? v.toDouble() : (v is bool ? (v ? 1.0 : 0.0) : 0.0);
bool _toBool(dynamic v) => v is bool ? v : _toInt(v) != 0;
String _toStr(dynamic v) => v as String;
String _toChar(dynamic v) => v as String;
List<int> _toIntArr(dynamic v) => (v as List).map(_toInt).toList();
List<double> _toDblArr(dynamic v) => (v as List).map(_toDbl).toList();
List<bool> _toBoolArr(dynamic v) => (v as List).map(_toBool).toList();
List<String> _toStrArr(dynamic v) => (v as List).map((e) => e as String).toList();
List<String> _toCharArr(dynamic v) => (v as List).map((e) => e as String).toList();
List<List<int>> _toIntArr2(dynamic v) => (v as List).map(_toIntArr).toList();
List<List<double>> _toDblArr2(dynamic v) => (v as List).map(_toDblArr).toList();
List<List<String>> _toCharArr2(dynamic v) => (v as List).map(_toCharArr).toList();
List<List<String>> _toStrArr2(dynamic v) => (v as List).map(_toStrArr).toList();

TreeNode? _toTree(dynamic v) {
  final a = v as List;
  if (a.isEmpty || a[0] == null) return null;
  final root = TreeNode(_toInt(a[0]));
  final q = <TreeNode>[root];
  int qi = 0, i = 1;
  while (i < a.length && qi < q.length) {
    final n = q[qi++];
    if (i < a.length) { if (a[i] != null) { n.left = TreeNode(_toInt(a[i])); q.add(n.left!); } i++; }
    if (i < a.length) { if (a[i] != null) { n.right = TreeNode(_toInt(a[i])); q.add(n.right!); } i++; }
  }
  return root;
}
ListNode? _toListN(dynamic v) {
  final a = v as List;
  if (a.isEmpty) return null;
  final head = ListNode(_toInt(a[0]));
  var c = head;
  for (var i = 1; i < a.length; i++) { c.next = ListNode(_toInt(a[i])); c = c.next!; }
  return head;
}
List<int> _listVals(ListNode? n) { final r = <int>[]; var c = n; while (c != null) { r.add(c.val); c = c.next; } return r; }
List<int> _treeVals(TreeNode? r) {
  final o = <int>[]; final q = <TreeNode>[]; if (r != null) q.add(r); var i = 0;
  while (i < q.length) { final n = q[i++]; o.add(n.val); if (n.left != null) q.add(n.left!); if (n.right != null) q.add(n.right!); }
  return o;
}

String _q(String s) {
  final b = StringBuffer('"');
  for (final ch in s.split('')) { if (ch == '"' || ch == '\\') b.write('\\'); b.write(ch); }
  b.write('"');
  return b.toString();
}
String _fmtG(double d) {
  var s = d.toStringAsPrecision(6);
  if (s.contains('.') && !s.contains('e') && !s.contains('E')) {
    s = s.replaceFirst(RegExp(r'0+$'), '');
    s = s.replaceFirst(RegExp(r'\.$'), '');
  }
  return s;
}
String _cv(dynamic v) {
  if (v == null) return 'null';
  if (v is bool) return v ? 'true' : 'false';
  if (v is int) return v.toString();
  if (v is double) {
    if (v.isFinite && v == v.roundToDouble() && v.abs() < 9.007199254740992e15) return v.toInt().toString();
    return _fmtG(v);
  }
  if (v is String) return _q(v);
  if (v is List) return '[' + v.map(_cv).join(',') + ']';
  return 'null';
}
String _mset(dynamic v) {
  final cs = (v as List).map(_cv).toList()..sort();
  return '[' + cs.join(',') + ']';
}
// A double result matches within 1e-5 (LeetCode's float problems accept that).
bool _feq(dynamic a, dynamic e) {
  if (a is List && e is List) {
    if (a.length != e.length) return false;
    for (var i = 0; i < a.length; i++) { if (!_feq(a[i], e[i])) return false; }
    return true;
  }
  if (a is num && e is num) return a == e || (a - e).abs() <= 1e-5;
  return _cv(a) == _cv(e);
}
"""


# ── arg marshalling ────────────────────────────────────────────────────────────
def _marshal_call(norm, srcexpr):
    args = []
    for i, n in enumerate(norm):
        src = srcexpr(i)
        if n in _SCALAR:       args.append("%s(%s)" % (_SCALAR_MARSHAL[n], src))
        elif n == "string":    args.append("_toStr(%s)" % src)
        elif n in _ARR:        args.append("%s(%s)" % (_ARR[n][1], src))
        elif n == "TreeNode*": args.append("_toTree(%s)" % src)
        elif n == "ListNode*": args.append("_toListN(%s)" % src)
        else: raise ValueError(n)
    return args


def _canon_result(retn, callexpr):
    if retn == "ListNode*": return "_cv(_listVals(%s))" % callexpr
    if retn == "TreeNode*": return "_cv(_treeVals(%s))" % callexpr
    return "_cv(%s)" % callexpr


# ── validate / measure mains ───────────────────────────────────────────────────
def gen_validate(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    args = _marshal_call(info["norm"], lambda i: "inp[%d]" % i)
    call = "Solution().%s(%s)" % (info["method"], ", ".join(args))
    unordered = slug in _UNORDERED
    if unordered and info["retn"] in _ARR:
        actual = "_mset(%s)" % call
        exp = "_mset(kase['output'])"
    else:
        actual = _canon_result(info["retn"], call)
        exp = "_cv(kase['output'])"
    ok = "exp == actual"
    if not unordered and info["retn"] in ("double", "vector<double>"):
        actual = "_cv(raw = %s)" % call      # keep the raw value for _feq
        ok = "_feq(raw, kase['output'])"
    body = r'''
void main() {
  final doc = jsonDecode(File(r'__OUTS__').readAsStringSync());
  const slug = '__SLUG__';
  final cases = (doc['expected'] as List);
  for (var ci = 0; ci < cases.length; ci++) {
    final kase = cases[ci];
    final name = (kase['name'] ?? 'case').toString();
    final inp = (kase['input'] as Map).values.toList();
    dynamic raw;
    var actual = '';
    try {
      actual = __ACTUAL__;
    } catch (e) {
      stderr.writeln('VALIDATE slug=$slug RE case=$name passed=$ci ncases=${cases.length} $e');
      exit(3);
    }
    final exp = __EXP__;
    if (!(__OK__)) {
      String cut(String s) => s.length > 120 ? s.substring(0, 120) : s;
      stderr.writeln('VALIDATE slug=$slug FAIL case=$name passed=$ci ncases=${cases.length} expected=${cut(exp)} actual=${cut(actual)}');
      exit(1);
    }
  }
  stderr.writeln('VALIDATE slug=$slug PASS ncases=${cases.length} passed=${cases.length}');
  exit(0);
}
'''
    body = (body.replace("__OUTS__", outs).replace("__SLUG__", slug)
                .replace("__ACTUAL__", actual).replace("__EXP__", exp).replace("__OK__", ok))
    return body


# Copy and compare helpers for the measure driver. Trees and lists use a queue
# or a loop, so a 1e5-node chain needs no deep recursion.
COPY_HELPERS = r"""
TreeNode? _copyTree(TreeNode? r) {   // level order, as _toTree builds it
  if (r == null) return null;
  final root = TreeNode(r.val);
  final qs = <TreeNode>[r], qd = <TreeNode>[root];
  for (var i = 0; i < qs.length; i++) {
    final s = qs[i], d = qd[i];
    final l = s.left, rr = s.right;
    if (l != null) { final c = TreeNode(l.val); d.left = c; qs.add(l); qd.add(c); }
    if (rr != null) { final c = TreeNode(rr.val); d.right = c; qs.add(rr); qd.add(c); }
  }
  return root;
}
ListNode? _copyListN(ListNode? h) {
  if (h == null) return null;
  final head = ListNode(h.val);
  var d = head;
  for (var s = h.next; s != null; s = s.next) { final c = ListNode(s.val); d.next = c; d = c; }
  return head;
}
// Does b (a copy after one call) still equal the base a? Lists element by
// element, trees in level order with null markers, linked lists value by value.
// The walks follow the base, which has no cycles, so they end even when the
// solution leaves one in b.
bool _same(Object? a, Object? b) {
  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) { if (!_same(a[i], b[i])) return false; }
    return true;
  }
  return a == b;   // a NaN never equals itself: copy mode
}
bool _sameTree(TreeNode? a, TreeNode? b) {
  final qa = <TreeNode?>[a], qb = <TreeNode?>[b];
  for (var i = 0; i < qa.length; i++) {
    final x = qa[i], y = qb[i];
    if (x == null && y == null) continue;
    if (x == null || y == null || x.val != y.val) return false;
    qa..add(x.left)..add(x.right); qb..add(y.left)..add(y.right);
  }
  return true;
}
bool _sameListN(ListNode? a, ListNode? b) {
  var x = a, y = b;
  while (x != null) {
    if (y == null || y.val != x.val) return false;
    x = x.next; y = y.next;
  }
  return y == null;
}
"""


def _copy_expr(n, src):
    """A fresh copy of a mutable input (a list or a node), made from the base."""
    if n == "TreeNode*": return "_copyTree(%s)" % src
    if n == "ListNode*": return "_copyListN(%s)" % src
    t = _ARR[n][0]
    if t.startswith("List<List<"): return "%s.map((e) => %s.of(e)).toList()" % (src, t[5:-1])
    return "%s.of(%s)" % (t, src)


def _same_expr(n, a, b):
    if n == "TreeNode*": return "_sameTree(%s, %s)" % (a, b)
    if n == "ListNode*": return "_sameListN(%s, %s)" % (a, b)
    return "_same(%s, %s)" % (a, b)


def gen_measure(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    norm = info["norm"]
    ks = range(len(norm))
    bases = _marshal_call(norm, lambda i: "inp[%d]" % i)
    params = ", ".join("%s x%d" % (_dart_type(n), i) for i, n in enumerate(norm))
    call = "Solution().%s(%s)" % (info["method"], ", ".join("x%d" % i for i in ks))
    # Lists and nodes are mutable; ints, doubles, bools and strings are not.
    muts = [i for i, n in enumerate(norm) if n in _ARR or n in ("TreeNode*", "ListNode*")]
    base_args = ", ".join("b%d" % i for i in ks)
    fresh_args = ", ".join("f%d()" % i if i in muts else "b%d" % i for i in ks)
    copy_args = ", ".join("p%d[b]" % i if i in muts else "b%d" % i for i in ks)
    fold = "for (final c in doCall(%s).codeUnits) { acc = (acc * 1000003 + c) & 0x7fffffffffffffff; }"
    shared_loop = "for (var b = 0; b < batch; b++) { %s }" % (fold % base_args)
    if muts:
        check = ("".join("  %s f%d() => %s;\n" % (_dart_type(norm[i]), i, _copy_expr(norm[i], "b%d" % i))
                         for i in muts)
                 + "  // one call on fresh copies: does the solution change its input?\n"
                 + "".join("  final c%d = f%d();\n" % (i, i) for i in muts)
                 + "  doCall(%s);\n" % ", ".join("c%d" % i if i in muts else "b%d" % i for i in ks)
                 + "  final shared = %s;" % " && ".join(_same_expr(norm[i], "b%d" % i, "c%d" % i)
                                                        for i in muts))
        pools = "\n".join("  final p%d = <%s>[];" % (i, _dart_type(norm[i])) for i in muts)
        fill = " ".join("p%d.clear(); for (var k = 0; k < batch; k++) { p%d.add(f%d()); }" % (i, i, i)
                        for i in muts)
        timed = ("if (shared) { %s } else {\n"
                 "      for (var b = 0; b < batch; b++) { %s }\n    }" % (shared_loop, fold % copy_args))
    else:
        check, pools, fill, timed = "  final shared = true;", "", "", shared_loop
    body = r'''
void main(List<String> argv) {
  final doc = jsonDecode(File(r'__OUTS__').readAsStringSync());
  final budget = double.parse(argv[0]);
  final idx = int.parse(argv[1]);
  final cases = (doc['expected'] as List);
  final kase = cases[idx];
  final name = (kase['name'] ?? 'case').toString();
  final inp = (kase['input'] as Map).values.toList();
  // The inputs are marshalled ONCE (b0, b1, ...). If one call on fresh copies
  // shows that the solution does not change its lists and nodes, every call
  // gets the base ("shared"). If it does, every call gets its own copies,
  // made outside the timed region.
__BASES__
  String doCall(__PARAMS__) => __BEACON__;
__CHECK__
  var acc = 0; var iters = 0;
  final warm = budget * 0.3;
  final sw = Stopwatch()..start();
  var wi = 0;
  while (sw.elapsedMicroseconds / 1e6 < warm) { if (shared) { doCall(__BASE_ARGS__); } else { doCall(__FRESH_ARGS__); } wi++; }
  final per = wi > 0 ? (sw.elapsedMicroseconds / 1e6) / wi : warm;
  var batch = 4096;
  if (per > 0) { final bb = (0.002 / per).floor(); batch = bb < 1 ? 1 : (bb > 4096 ? 4096 : bb); }
  // the memory pass makes one copy at a time, so its peak RSS holds one copy
  if (!shared && (Platform.environment['PERFARENA_MEM_PASS'] ?? '').isNotEmpty) batch = 1;
  // MEAS_S is the sum of the timed segments (the calls and the fold only); the
  // measured phase also stops at 4x its target, which only matters when the
  // copies are expensive.
  final target = budget - warm;
  final cap = target * 4;
  var meas = 0.0;
__POOLS__
  final tm = Stopwatch()..start();
  while (meas < target && tm.elapsedMicroseconds / 1e6 < cap) {
    if (!shared) { __FILL__ }
    final t = tm.elapsedTicks;
    __TIMED__
    meas += (tm.elapsedTicks - t) / tm.frequency;
    iters += batch;
  }
  final beacon = doCall(__FRESH_ARGS__);
  stderr.writeln('CASE=$name ITERS=$iters ACC=$acc MEAS_S=${meas.toStringAsFixed(6)} BEACON=$beacon');
}
'''
    body = (body.replace("__OUTS__", outs)
                .replace("__BASES__", "\n".join("  final b%d = %s;" % (i, a) for i, a in enumerate(bases)))
                .replace("__PARAMS__", params)
                .replace("__BEACON__", _canon_result(info["retn"], call))
                .replace("__CHECK__", check).replace("__POOLS__", pools).replace("__FILL__", fill)
                .replace("__TIMED__", timed)
                .replace("__BASE_ARGS__", base_args).replace("__FRESH_ARGS__", fresh_args))
    return (COPY_HELPERS if muts else "") + body


# ── design mains ────────────────────────────────────────────────────────────────
def _design_construct(className, cnorm):
    args = _marshal_call(cnorm, lambda i: "ar[0][%d]" % i)
    return "var obj = %s(%s);" % (className, ", ".join(args))


def _design_dispatch(className, methods):
    lines = []
    for op, retn, mnorm in methods:
        margs = _marshal_call(mnorm, lambda i: "aa[%d]" % i)
        callexpr = "obj.%s(%s)" % (op, ", ".join(margs))
        if retn == "void":
            lines.append('      if (op == "%s") { %s; if (rec) res.add("null"); }' % (op, callexpr))
        else:
            lines.append('      if (op == "%s") { final rv = %s; if (rec) res.add(_cv(rv)); }' % (op, callexpr))
    return "\n".join(lines)


def gen_validate_design(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    className, cnorm, methods = info["design"]
    randomized = "true" if slug == "random-pick-index" else "false"
    body = r'''
void main() {
  final doc = jsonDecode(File(r'__OUTS__').readAsStringSync());
  const slug = '__SLUG__';
  const randomized = __RAND__;
  final cases = (doc['expected'] as List);
  for (var ci = 0; ci < cases.length; ci++) {
    final kase = cases[ci];
    final name = (kase['name'] ?? 'case').toString();
    final ops = (kase['input']['ops'] as List);
    final ar = (kase['input']['args'] as List);
    final res = <String>[]; const rec = true;
    try {
      __CONSTRUCT__
      res.add("null");
      for (var i = 1; i < ops.length; i++) {
        final op = ops[i] as String;
        final aa = (ar[i] as List);
__DISPATCH__
      }
    } catch (e) {
      stderr.writeln('VALIDATE slug=$slug RE case=$name passed=$ci ncases=${cases.length} $e');
      exit(3);
    }
    if (randomized) {
      final nums = (ar[0][0] as List);
      for (var i = 1; i < ops.length; i++) { if (ops[i] == 'pick' && i < res.length) { res[i] = _cv(nums[int.parse(res[i])]); } }
    }
    final exp = (kase['output'] as List);
    if (exp.length != res.length) {
      stderr.writeln('VALIDATE slug=$slug FAIL case=$name passed=$ci ncases=${cases.length} size exp=${exp.length} act=${res.length}');
      exit(1);
    }
    for (var i = 0; i < exp.length; i++) {
      if (exp[i] == null) continue;
      final e2 = _cv(exp[i]);
      if (e2 != res[i]) {
        stderr.writeln('VALIDATE slug=$slug FAIL case=$name passed=$ci ncases=${cases.length} pos=$i expected=$e2 actual=${res[i]}');
        exit(1);
      }
    }
  }
  stderr.writeln('VALIDATE slug=$slug PASS ncases=${cases.length} passed=${cases.length}');
  exit(0);
}
'''
    body = (body.replace("__OUTS__", outs).replace("__SLUG__", slug).replace("__RAND__", randomized)
                .replace("__CONSTRUCT__", _design_construct(className, cnorm))
                .replace("__DISPATCH__", _design_dispatch(className, methods)))
    return body


def gen_measure_design(slug, info):
    """One replay = construct the object, then call every op of the case; each
    op's canonical result (null for a void op) is folded into the replay's
    checksum. The replays are counted over the measured window, as for a plain
    call."""
    outs = os.path.join(REF, "outputs", slug + ".json")
    className, cnorm, methods = info["design"]
    body = r'''
void main(List<String> argv) {
  final doc = jsonDecode(File(r'__OUTS__').readAsStringSync());
  final budget = double.parse(argv[0]);
  final idx = int.parse(argv[1]);
  final cases = (doc['expected'] as List);
  final kase = cases[idx];
  final name = (kase['name'] ?? 'case').toString();
  final ops = (kase['input']['ops'] as List);
  final ar = (kase['input']['args'] as List);
  int replay() {
    final res = <String>[]; const rec = true;
    __CONSTRUCT__
    for (var i = 1; i < ops.length; i++) {
      final op = ops[i] as String;
      final aa = (ar[i] as List);
__DISPATCH__
    }
    var h = 0;
    for (final r in res) { for (final c in r.codeUnits) { h = (h * 1000003 + c) & 0x7fffffffffffffff; } }
    return h;
  }
  var acc = 0; var iters = 0;
  final warm = budget * 0.3;
  final sw = Stopwatch()..start();
  var wi = 0;
  while (sw.elapsedMicroseconds / 1e6 < warm) { replay(); wi++; }
  final per = wi > 0 ? (sw.elapsedMicroseconds / 1e6) / wi : warm;
  var batch = 4096;
  if (per > 0) { final bb = (0.002 / per).floor(); batch = bb < 1 ? 1 : (bb > 4096 ? 4096 : bb); }
  final tm = Stopwatch()..start();
  while (tm.elapsedMicroseconds / 1e6 < budget - warm) {
    for (var b = 0; b < batch; b++) { acc = (acc * 1000003 + replay()) & 0x7fffffffffffffff; }
    iters += batch;
  }
  final meas = tm.elapsedMicroseconds / 1e6;
  stderr.writeln('CASE=$name ITERS=$iters ACC=$acc MEAS_S=${meas.toStringAsFixed(6)} BEACON=design');
}
'''
    return (body.replace("__OUTS__", outs)
                .replace("__CONSTRUCT__", _design_construct(className, cnorm))
                .replace("__DISPATCH__", _design_dispatch(className, methods)))


# ── build (dart) & run ────────────────────────────────────────────────────────
def _build(slug, mode):
    info = analyze(slug)
    if info["kind"] == "unsupported":
        return None, info, info.get("reason", "unsupported")
    if info["kind"] == "design":
        drv = gen_validate_design(slug, info) if mode == "validate" else gen_measure_design(slug, info)
    else:
        drv = gen_validate(slug, info) if mode == "validate" else gen_measure(slug, info)
    cell = os.path.join(ROOT, "Dart", "leetcode", slug)
    sol = open(os.path.join(cell, "solution.dart")).read()
    tmp = tempfile.mkdtemp(prefix="hz_dart_%s_" % mode)
    open(os.path.join(tmp, "nodes.dart"), "w").write(NODES)
    # The cell solution references TreeNode/ListNode unqualified (the judge
    # injects them); import nodes.dart so they resolve, unless it defines its own.
    needs_nodes = ("TreeNode" in sol or "ListNode" in sol) and "class TreeNode" not in sol and "class ListNode" not in sol
    sol_out = ("import 'nodes.dart';\n" + sol) if needs_nodes else sol
    open(os.path.join(tmp, "solution.dart"), "w").write(sol_out)
    main = "import 'dart:io';\nimport 'dart:convert';\nimport 'nodes.dart';\nimport 'solution.dart';\n" + PRELUDE + drv
    mainp = os.path.join(tmp, "main.dart")
    open(mainp, "w").write(main)
    return mainp, info, tmp


def build_and_validate(slug):
    mainp, info, tmp = _build(slug, "validate")
    if mainp is None:
        sys.stderr.write("VALIDATE slug=%s ERROR %s\n" % (slug, tmp))
        return 2
    try:
        rr = subprocess.run([DART, "run", "--enable-asserts", mainp],
                            capture_output=True, text=True, timeout=300)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    if rr.stdout and rr.returncode == 254: sys.stderr.write(rr.stdout)
    if rr.stderr: sys.stderr.write(rr.stderr)
    # The Dart VM exits 254 on a compile error and 255 on an uncaught exception;
    # a signal (negative returncode) is a crash too.
    if rr.returncode < 0:
        return 3
    return {254: 2, 255: 3}.get(rr.returncode, rr.returncode)


def compile_check(slug):
    """The cell Makefile's compile check: the validation driver with the
    solution, compiled to kernel in a temp dir. Runs nothing."""
    mainp, info, tmp = _build(slug, "validate")
    if mainp is None:
        sys.stderr.write("compile check %s: %s\n" % (slug, tmp))
        return 2
    try:
        rr = subprocess.run([DART, "compile", "kernel", mainp, "-o", os.path.join(tmp, "main.dill")],
                            capture_output=True, text=True, timeout=600)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    if rr.returncode != 0:
        sys.stderr.write(rr.stdout + rr.stderr)
    return 0 if rr.returncode == 0 else 1


def build_driver(slug):
    """The measure driver compiled ONCE, ahead of time, to the cell's
    .perf_build/driver, so a measured run never includes the compiler."""
    mainp, info, tmp = _build(slug, "measure")
    if mainp is None:
        sys.stderr.write("TODO/compile_error %s: %s\n" % (slug, tmp))
        return 1
    dest = os.path.join(os.getcwd(), ".perf_build")
    shutil.rmtree(dest, ignore_errors=True)
    os.makedirs(dest)
    try:
        rr = subprocess.run([DART, "compile", "exe", mainp, "-o", os.path.join(dest, "driver")],
                            capture_output=True, text=True, timeout=600)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    if rr.returncode != 0:
        sys.stderr.write(rr.stdout + rr.stderr)
        return 1
    return 0


def build_and_run(slug, budget, idx):
    mainp, info, tmp = _build(slug, "measure")
    if mainp is None:
        return "compile_error", tmp, None
    rr = subprocess.run([DART, "run", mainp, str(budget), str(idx)],
                        capture_output=True, text=True, timeout=max(30, budget * 4 + 20))
    if rr.returncode != 0:
        return "runtime_error", (rr.stderr.strip().splitlines()[-1] if rr.stderr else "rc=%d" % rr.returncode), None
    return "ok", rr.stderr.strip(), None


def main():
    if len(sys.argv) > 1 and sys.argv[1] == "validate":
        sys.exit(build_and_validate(os.path.basename(os.getcwd())))
    if len(sys.argv) > 1 and sys.argv[1] == "check":
        sys.exit(compile_check(os.path.basename(os.getcwd())))
    if len(sys.argv) > 1 and sys.argv[1] == "build":
        sys.exit(build_driver(os.path.basename(os.getcwd())))
    budget = float(sys.argv[1]) if len(sys.argv) > 1 else 1.0
    idx = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    status, msg, _ = build_and_run(os.path.basename(os.getcwd()), budget, idx)
    if status == "ok":
        print(msg, file=sys.stderr)
    else:
        print("TODO/%s %s: %s" % (status, os.path.basename(os.getcwd()), msg), file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
