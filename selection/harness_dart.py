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
    python3 harness_dart.py validate      -> exit 0/1/3 (Accepted/WA/RE), 2 setup
    python3 harness_dart.py <budget> <idx> -> perf line on stderr
"""
import json, os, re, subprocess, sys, tempfile
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
    body = r'''
void main() {
  final doc = jsonDecode(File(r'__OUTS__').readAsStringSync());
  const slug = '__SLUG__';
  final cases = (doc['expected'] as List);
  for (var ci = 0; ci < cases.length; ci++) {
    final kase = cases[ci];
    final name = (kase['name'] ?? 'case').toString();
    final inp = (kase['input'] as Map).values.toList();
    final actual = __ACTUAL__;
    final exp = __EXP__;
    if (exp != actual) {
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
                .replace("__ACTUAL__", actual).replace("__EXP__", exp))
    return body


def gen_measure(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    args = _marshal_call(info["norm"], lambda i: "inp[%d]" % i)
    call = "Solution().%s(%s)" % (info["method"], ", ".join(args))
    beacon = _canon_result(info["retn"], call)
    body = r'''
void main(List<String> argv) {
  final doc = jsonDecode(File(r'__OUTS__').readAsStringSync());
  final budget = double.parse(argv[0]);
  final idx = int.parse(argv[1]);
  final cases = (doc['expected'] as List);
  final kase = cases[idx];
  final name = (kase['name'] ?? 'case').toString();
  final inp = (kase['input'] as Map).values.toList();
  String doCall() => __BEACON__;
  var acc = 0; var iters = 0;
  final warm = budget * 0.3;
  final sw = Stopwatch()..start();
  var wi = 0;
  while (sw.elapsedMicroseconds / 1e6 < warm) { doCall(); wi++; }
  final per = wi > 0 ? (sw.elapsedMicroseconds / 1e6) / wi : warm;
  var batch = 4096;
  if (per > 0) { final bb = (0.002 / per).floor(); batch = bb < 1 ? 1 : (bb > 4096 ? 4096 : bb); }
  final tm = Stopwatch()..start();
  while (tm.elapsedMicroseconds / 1e6 < budget - warm) {
    for (var b = 0; b < batch; b++) { for (final c in doCall().codeUnits) { acc = (acc * 1000003 + c) & 0x7fffffffffffffff; } }
    iters += batch;
  }
  final meas = tm.elapsedMicroseconds / 1e6;
  final beacon = doCall();
  stderr.writeln('CASE=$name ITERS=$iters ACC=$acc MEAS_S=${meas.toStringAsFixed(6)} BEACON=$beacon');
}
'''
    body = body.replace("__OUTS__", outs).replace("__BEACON__", beacon)
    return body


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
    __CONSTRUCT__
    res.add("null");
    for (var i = 1; i < ops.length; i++) {
      final op = ops[i] as String;
      final aa = (ar[i] as List);
__DISPATCH__
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


# ── build (dart) & run ────────────────────────────────────────────────────────
def _build(slug, mode):
    info = analyze(slug)
    if info["kind"] == "unsupported":
        return None, info, info.get("reason", "unsupported")
    if info["kind"] == "design":
        if mode != "validate":
            return None, info, "Dart: design measure not implemented"
        drv = gen_validate_design(slug, info)
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
    rr = subprocess.run([DART, "run", "--enable-asserts", mainp],
                        capture_output=True, text=True, timeout=300)
    if rr.stderr: sys.stderr.write(rr.stderr)
    return rr.returncode


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
