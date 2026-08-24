#!/usr/bin/env python3
"""Scala full-suite validator + perf harness for the leetcode cells.

Scala runs on the JVM but LeetCode's shape is `object Solution { def m(...) }`
with `Array[Int]` (= JVM int[]) arguments, so — like harness_swift — this is a
self-contained codegen harness: the DRIVER is itself Scala, compiled alongside
solution.scala, so it calls `Solution.m(...)` / `new DesignClass(...)` directly
(no reflection). It reuses harness_cpp.analyze() for the logical shape and maps
each C++ type to the deterministic LeetCode-Scala type.

LeetCode Scala shape:
  * `object Solution { def m(a: T, ...): R = { } }`
  * design: `class Name(_a: Int) { def op(x: Int): R = { } }`  (new Name(...))
  * nodes:  `class TreeNode(_value, _left, _right){ var value; var left; var right }`
            `class ListNode(_x, _next){ var x; var next }`

The driver carries its own ordered, lossless JSON parser so ordering + big-int
precision match the C++/C/Swift harnesses exactly.

Contract (run FROM the cell dir):
    python3 harness_scala.py validate      -> exit 0/1/3 (Accepted/WA/RE), 2 setup
    python3 harness_scala.py <budget> <idx> -> perf line on stderr
"""
import json, os, subprocess, sys, tempfile
import harness_cpp as cpp

ROOT = cpp.ROOT
REF  = cpp.REF
_UNORDERED = cpp._UNORDERED

_SCALAR = {"int": "Int", "long": "Long", "longlong": "Long",
           "double": "Double", "bool": "Boolean", "char": "Char"}
_SCALAR_MARSHAL = {"int": "toInt", "long": "toLong", "longlong": "toLong",
                   "double": "toDbl", "bool": "toBool", "char": "toChar"}
_ARR = {
    "vector<int>": ("Array[Int]", "toIntArr"), "vector<longlong>": ("Array[Long]", "toLongArr"),
    "vector<long>": ("Array[Long]", "toLongArr"), "vector<double>": ("Array[Double]", "toDblArr"),
    "vector<bool>": ("Array[Boolean]", "toBoolArr"), "vector<char>": ("Array[Char]", "toCharArr"),
    "vector<string>": ("Array[String]", "toStrArr"),
    "vector<vector<int>>": ("Array[Array[Int]]", "toIntArr2"),
    "vector<vector<double>>": ("Array[Array[Double]]", "toDblArr2"),
    "vector<vector<char>>": ("Array[Array[Char]]", "toCharArr2"),
    "vector<vector<string>>": ("Array[Array[String]]", "toStrArr2"),
}


def _scala_type(norm):
    if norm in _SCALAR: return _SCALAR[norm]
    if norm == "string": return "String"
    if norm in _ARR: return _ARR[norm][0]
    if norm in ("TreeNode*", "ListNode*"): return norm[:-1]
    return None


# LeetCode Scala mixes Array (inputs) and List (some returns/params), so the
# param marshaller is driven by the ACTUAL Scala signature, not the logical
# C++ type. Map a Scala type string -> its marshaller.
import re as _re
_SMAR = {
    "Int": "toInt", "Long": "toLong", "Double": "toDbl", "Boolean": "toBool",
    "Char": "toChar", "String": "toStr",
    "Array[Int]": "toIntArr", "Array[Long]": "toLongArr", "Array[Double]": "toDblArr",
    "Array[Boolean]": "toBoolArr", "Array[Char]": "toCharArr", "Array[String]": "toStrArr",
    "Array[Array[Int]]": "toIntArr2", "Array[Array[Double]]": "toDblArr2",
    "Array[Array[Char]]": "toCharArr2", "Array[Array[String]]": "toStrArr2",
    "List[Int]": "toIntList", "List[Long]": "toLongList", "List[Double]": "toDblList",
    "List[Boolean]": "toBoolList", "List[Char]": "toCharList", "List[String]": "toStrList",
    "List[List[Int]]": "toIntList2", "List[List[String]]": "toStrList2",
    "TreeNode": "toTree", "ListNode": "toList",
}


def _split_top(s):
    out, d, cur = [], 0, ""
    for c in s:
        if c in "[(": d += 1
        elif c in "])": d -= 1
        if c == "," and d == 0: out.append(cur); cur = ""
        else: cur += c
    if cur.strip(): out.append(cur)
    return out


def _scala_sig(slug, method):
    """(param_scala_types, ret_scala_type) parsed from the official scala snippet."""
    sc = (json.load(open(os.path.join(ROOT, "Java", "leetcode", slug, "problem.json")))
          .get("code_snippets") or {}).get("scala", "")
    m = _re.search(r'\bdef\s+' + _re.escape(method) + r'\s*\((.*?)\)\s*:\s*([^=]+?)\s*=', sc, _re.S)
    if not m:
        return None
    ptypes = [_re.sub(r'\s+', '', p.split(':', 1)[1]) for p in _split_top(m.group(1)) if ':' in p]
    return ptypes, _re.sub(r'\s+', '', m.group(2))


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
                        reason="Scala: design method returns/params not handled")
        return dict(kind="design", method=info["method"], design=d)
    if info["kind"] == "plain":
        norm = list(info["ptypes"]); retn = _norm_ret(info["ret"])
    else:
        norm = [_norm_ret(r) if ("TreeNode" in r or "ListNode" in r) else cpp._norm(r)
                for r in info["praw"]]
        retn = _norm_ret(info["ret"])
    # marshalling is driven by the ACTUAL Scala signature (Array vs List)
    sig = _scala_sig(slug, info["method"])
    if sig is None:
        return dict(kind="unsupported", method=info["method"], reason="Scala: cannot parse signature")
    stypes, _sret = sig
    if len(stypes) != len(norm):
        return dict(kind="unsupported", method=info["method"], reason="Scala: signature arity mismatch")
    for st in stypes:
        if st not in _SMAR:
            return dict(kind="unsupported", method=info["method"],
                        reason="Scala: unhandled param type '%s'" % st)
    return dict(kind=info["kind"], method=info["method"], ret=info["ret"],
                retn=retn, norm=norm, stypes=stypes)


def _design_info(slug):
    sol = os.path.join(ROOT, "C++", "leetcode", slug, "solution.cpp")
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
        if retn != "void" and _scala_type(retn) is None:
            return None
        for t in cnorm + mnorm:
            if _scala_type(t) is None:
                return None
        methods.append((name, retn, mnorm))
    return className, cnorm, methods


# ── Scala prelude ───────────────────────────────────────────────────────────────
NODES = """
class TreeNode(_value: Int = 0, _left: TreeNode = null, _right: TreeNode = null) {
  var value: Int = _value; var left: TreeNode = _left; var right: TreeNode = _right
}
class ListNode(_x: Int = 0, _next: ListNode = null) {
  var next: ListNode = _next; var x: Int = _x
}
"""

PRELUDE = r"""
object H {
  sealed trait J
  case object JNull extends J
  case class JBool(b: Boolean) extends J
  case class JNum(r: String) extends J
  case class JStr(s: String) extends J
  case class JArr(a: Array[J]) extends J
  case class JObj(o: Array[(String, J)]) extends J

  final class JP(t: String) {
    val s = t.toCharArray; var p = 0
    def ws(): Unit = { while (p < s.length && (s(p)==' '||s(p)=='\n'||s(p)=='\t'||s(p)=='\r')) p += 1 }
    def value(): J = { ws(); s(p) match {
      case '{' => objv(); case '[' => arrv(); case '"' => JStr(strv())
      case 't' => p += 4; JBool(true); case 'f' => p += 5; JBool(false)
      case 'n' => p += 4; JNull; case _ => numv() } }
    def strv(): String = { val b = new StringBuilder; p += 1
      var go = true
      while (go && p < s.length) { val c = s(p); p += 1
        if (c == '"') go = false
        else if (c == '\\') { val e = s(p); p += 1; e match {
          case 'n' => b += '\n'; case 't' => b += '\t'; case 'r' => b += '\r'
          case 'b' => b += '\b'; case 'f' => b += '\f'; case '/' => b += '/'
          case '"' => b += '"'; case '\\' => b += '\\'
          case 'u' => val cp = Integer.parseInt(new String(s, p, 4), 16); p += 4; b.append(cp.toChar)
          case _ => b += e } }
        else b += c }
      b.toString }
    def numv(): J = { val st = p
      while (p < s.length && (s(p).isDigit || "+-.eE".indexOf(s(p)) >= 0)) p += 1
      JNum(new String(s, st, p - st)) }
    def arrv(): J = { val buf = scala.collection.mutable.ArrayBuffer[J](); p += 1; ws()
      if (s(p) == ']') { p += 1; JArr(buf.toArray) } else {
        var go = true
        while (go) { buf += value(); ws(); if (s(p) == ',') { p += 1 } else { p += 1; go = false } }
        JArr(buf.toArray) } }
    def objv(): J = { val buf = scala.collection.mutable.ArrayBuffer[(String, J)](); p += 1; ws()
      if (s(p) == '}') { p += 1; JObj(buf.toArray) } else {
        var go = true
        while (go) { ws(); val k = strv(); ws(); p += 1; buf += ((k, value())); ws()
          if (s(p) == ',') { p += 1 } else { p += 1; go = false } }
        JObj(buf.toArray) } }
  }

  def field(j: J, k: String): J = j match { case JObj(o) => o.find(_._1 == k).map(_._2).getOrElse(JNull); case _ => JNull }
  def items(j: J): Array[J] = j match { case JArr(a) => a; case _ => Array() }
  def entries(j: J): Array[(String, J)] = j match { case JObj(o) => o; case _ => Array() }

  def toInt(j: J): Int = j match { case JNum(r) => try r.toInt catch { case _: Throwable => r.toDouble.toInt }; case JBool(b) => if (b) 1 else 0; case _ => 0 }
  def toLong(j: J): Long = j match { case JNum(r) => try r.toLong catch { case _: Throwable => r.toDouble.toLong }; case _ => 0L }
  def toDbl(j: J): Double = j match { case JNum(r) => r.toDouble; case _ => 0.0 }
  def toBool(j: J): Boolean = j match { case JBool(b) => b; case _ => toInt(j) != 0 }
  def toStr(j: J): String = j match { case JStr(s) => s; case _ => "" }
  def toChar(j: J): Char = { val s = toStr(j); if (s.isEmpty) ' ' else s.charAt(0) }
  def toIntArr(j: J): Array[Int] = items(j).map(toInt)
  def toLongArr(j: J): Array[Long] = items(j).map(toLong)
  def toDblArr(j: J): Array[Double] = items(j).map(toDbl)
  def toBoolArr(j: J): Array[Boolean] = items(j).map(toBool)
  def toStrArr(j: J): Array[String] = items(j).map(toStr)
  def toCharArr(j: J): Array[Char] = items(j).map(toChar)
  def toIntArr2(j: J): Array[Array[Int]] = items(j).map(toIntArr)
  def toDblArr2(j: J): Array[Array[Double]] = items(j).map(toDblArr)
  def toCharArr2(j: J): Array[Array[Char]] = items(j).map(toCharArr)
  def toStrArr2(j: J): Array[Array[String]] = items(j).map(toStrArr)
  def toIntList(j: J): List[Int] = items(j).map(toInt).toList
  def toLongList(j: J): List[Long] = items(j).map(toLong).toList
  def toDblList(j: J): List[Double] = items(j).map(toDbl).toList
  def toBoolList(j: J): List[Boolean] = items(j).map(toBool).toList
  def toStrList(j: J): List[String] = items(j).map(toStr).toList
  def toCharList(j: J): List[Char] = items(j).map(toChar).toList
  def toIntList2(j: J): List[List[Int]] = items(j).map(toIntList).toList
  def toStrList2(j: J): List[List[String]] = items(j).map(toStrList).toList
  def toTree(j: J): TreeNode = { val a = items(j); if (a.isEmpty || a(0) == JNull) return null
    val root = new TreeNode(toInt(a(0))); val q = scala.collection.mutable.ArrayBuffer[TreeNode](root); var qi = 0; var i = 1
    while (i < a.length && qi < q.length) { val n = q(qi); qi += 1
      if (i < a.length) { if (a(i) != JNull) { n.left = new TreeNode(toInt(a(i))); q += n.left }; i += 1 }
      if (i < a.length) { if (a(i) != JNull) { n.right = new TreeNode(toInt(a(i))); q += n.right }; i += 1 } }
    root }
  def toList(j: J): ListNode = { val a = items(j); if (a.isEmpty) return null
    val head = new ListNode(toInt(a(0))); var cur = head
    var i = 1; while (i < a.length) { cur.next = new ListNode(toInt(a(i))); cur = cur.next; i += 1 }
    head }
  def listVals(n0: ListNode): Array[Int] = { val b = scala.collection.mutable.ArrayBuffer[Int](); var n = n0; while (n != null) { b += n.x; n = n.next }; b.toArray }
  def treeVals(r: TreeNode): Array[Int] = { val o = scala.collection.mutable.ArrayBuffer[Int](); val q = scala.collection.mutable.ArrayBuffer[TreeNode](); if (r != null) q += r; var i = 0
    while (i < q.length) { val n = q(i); i += 1; o += n.value; if (n.left != null) q += n.left; if (n.right != null) q += n.right }; o.toArray }

  def q(s: String): String = { val b = new StringBuilder("\""); for (c <- s) { if (c == '"' || c == '\\') b += '\\'; b += c }; b += '"'; b.toString }
  def fmtG(d: Double): String = { var s = String.format("%.6g", java.lang.Double.valueOf(d))
    if (s.indexOf('e') < 0 && s.indexOf('E') < 0 && s.indexOf('.') >= 0) { s = s.replaceAll("0+$", ""); if (s.endsWith(".")) s = s.dropRight(1) }; s }
  def cv(x: Any): String = x match {
    case i: Int => i.toString
    case l: Long => l.toString
    case b: Boolean => if (b) "true" else "false"
    case d: Double => if (d.isFinite && d == Math.floor(d) && Math.abs(d) < 9.007199254740992e15) d.toLong.toString else fmtG(d)
    case c: Char => q(c.toString)
    case s: String => q(s)
    case a: Array[_] => "[" + a.map(cv).mkString(",") + "]"
    case s: Seq[_] => "[" + s.map(cv).mkString(",") + "]"
    case _ => "null" }
  def mset(x: Any): String = { val ps: Seq[String] = x match { case a: Array[_] => a.toIndexedSeq.map(cv); case s: Seq[_] => s.map(cv); case _ => Seq(cv(x)) }; "[" + ps.sorted.mkString(",") + "]" }
  def canonJSON(j: J): String = j match {
    case JNull => "null"; case JBool(b) => if (b) "true" else "false"; case JStr(s) => q(s)
    case JNum(r) => if (r.indexOf('.') >= 0 || r.indexOf('e') >= 0 || r.indexOf('E') >= 0) {
        val d = r.toDouble; if (d.isFinite && d == Math.floor(d) && Math.abs(d) < 9.007199254740992e15) d.toLong.toString else fmtG(d)
      } else JNum(r).r.toLong.toString
    case JArr(a) => "[" + a.map(canonJSON).mkString(",") + "]"; case _ => "null" }
  def canonJSONmset(j: J): String = j match { case JArr(a) => "[" + a.map(canonJSON).sorted.mkString(",") + "]"; case _ => canonJSON(j) }
  def nowS(): Double = System.nanoTime().toDouble / 1e9
  def fmtF(d: Double): String = String.format("%.6f", java.lang.Double.valueOf(d))
  def loadDoc(path: String): J = new JP(new String(java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(path)), "UTF-8")).value()
  def eprint(s: String): Unit = System.err.print(s)
}
"""


def _marshal_call(stypes, srcexpr):
    """stypes are Scala type strings (keys of _SMAR)."""
    return ["H.%s(%s)" % (_SMAR[st], srcexpr(i)) for i, st in enumerate(stypes)]


def _canon_result(retn, callexpr):
    if retn == "ListNode*": return "H.cv(H.listVals(%s))" % callexpr
    if retn == "TreeNode*": return "H.cv(H.treeVals(%s))" % callexpr
    return "H.cv(%s)" % callexpr


def _sol_receiver(slug):
    """LeetCode's Scala template is `object Solution`, but models routinely write
    `class Solution` (the "Solution class" system prompt). `Solution.m` only
    resolves for an object, so pick the receiver from what the solution actually
    defines: `object Solution` -> `Solution`, `class Solution` -> `(new Solution)`."""
    p = os.path.join(ROOT, "Scala", "leetcode", slug, "solution.scala")
    src = open(p).read() if os.path.exists(p) else ""
    if _re.search(r'\bobject\s+Solution\b', src):
        return "Solution"
    if _re.search(r'\bclass\s+Solution\b', src):
        return "(new Solution)"
    return "Solution"


def gen_validate(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    args = _marshal_call(info["stypes"], lambda i: "E(%d)._2" % i)
    call = "%s.%s(%s)" % (_sol_receiver(slug), info["method"], ", ".join(args))
    unordered = slug in _UNORDERED
    if unordered and info["retn"] in _ARR:
        actual = "H.mset(%s)" % call; exp = "H.canonJSONmset(outV)"
    else:
        actual = _canon_result(info["retn"], call); exp = "H.canonJSON(outV)"
    body = r'''
object Main {
  def main(argv: Array[String]): Unit = {
    val doc = H.loadDoc("__OUTS__"); val slug = "__SLUG__"
    val cases = H.items(H.field(doc, "expected"))
    var ci = 0
    while (ci < cases.length) {
      val kase = cases(ci)
      val name = H.field(kase, "name") match { case H.JStr(s) => s; case _ => "case" }
      val E = H.entries(H.field(kase, "input")); val _ = E
      val outV = H.field(kase, "output")
      val actual = __ACTUAL__
      val exp = __EXP__
      if (exp != actual) {
        H.eprint(s"VALIDATE slug=$slug FAIL case=$name passed=$ci ncases=${cases.length} expected=${exp.take(120)} actual=${actual.take(120)}\n")
        System.exit(1)
      }
      ci += 1
    }
    H.eprint(s"VALIDATE slug=$slug PASS ncases=${cases.length} passed=${cases.length}\n")
    System.exit(0)
  }
}
'''
    body = (body.replace("__OUTS__", outs).replace("__SLUG__", slug)
                .replace("__ACTUAL__", actual).replace("__EXP__", exp))
    return PRELUDE + body


def gen_measure(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    args = _marshal_call(info["stypes"], lambda i: "E(%d)._2" % i)
    call = "%s.%s(%s)" % (_sol_receiver(slug), info["method"], ", ".join(args))
    beacon = _canon_result(info["retn"], call)
    body = r'''
object Main {
  def main(argv: Array[String]): Unit = {
    val doc = H.loadDoc("__OUTS__")
    val budget = argv(0).toDouble; val idx = argv(1).toInt
    val cases = H.items(H.field(doc, "expected"))
    val kase = cases(idx)
    val name = H.field(kase, "name") match { case H.JStr(s) => s; case _ => "case" }
    val E = H.entries(H.field(kase, "input")); val _ = E
    def doCall(): String = __BEACON__
    var acc: Long = 0; var iters: Long = 0
    val warm = budget * 0.3
    val t0 = H.nowS(); var wi = 0L
    while (H.nowS() - t0 < warm) { doCall(); wi += 1 }
    val per = if (wi > 0) (H.nowS() - t0) / wi.toDouble else warm
    var batch = 4096L; if (per > 0) { val bb = (0.002 / per).toLong; batch = if (bb < 1) 1 else if (bb > 4096) 4096 else bb }
    val tm = H.nowS()
    while (H.nowS() - tm < budget - warm) { var b = 0L; while (b < batch) { val s = doCall(); var k = 0; while (k < s.length) { acc = acc * 1000003 + s.charAt(k).toLong; k += 1 }; b += 1 }; iters += batch }
    val meas = H.nowS() - tm
    val beacon = doCall()
    H.eprint(s"CASE=$name ITERS=$iters ACC=$acc MEAS_S=${H.fmtF(meas)} BEACON=$beacon\n")
  }
}
'''
    body = body.replace("__OUTS__", outs).replace("__BEACON__", beacon)
    # fmtF helper for %.6f
    return PRELUDE + body


# ── design ───────────────────────────────────────────────────────────────────
def _design_construct(className, cnorm):
    args = _marshal_call([_scala_type(n) for n in cnorm], lambda i: "H.items(AR(0))(%d)" % i)
    return "val obj = new %s(%s)" % (className, ", ".join(args))


def _design_dispatch(className, methods, fold):
    lines = []
    for op, retn, mnorm in methods:
        margs = _marshal_call([_scala_type(n) for n in mnorm], lambda i: "aa(%d)" % i)
        callexpr = "obj.%s(%s)" % (op, ", ".join(margs))
        if fold:
            if retn == "void":
                lines.append('        if (op == "%s") { %s; h = h * 1000003 + 3 }' % (op, callexpr))
            else:
                lines.append('        if (op == "%s") { val rv = %s; h = h * 1000003 + H.cv(rv).hashCode.toLong }' % (op, callexpr))
        else:
            if retn == "void":
                lines.append('        if (op == "%s") { %s; res += "null" }' % (op, callexpr))
            else:
                lines.append('        if (op == "%s") { val rv = %s; res += H.cv(rv) }' % (op, callexpr))
    return "\n".join(lines)


def gen_validate_design(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    className, cnorm, methods = info["design"]
    randomized = "true" if slug == "random-pick-index" else "false"
    body = r'''
object Main {
  def main(argv: Array[String]): Unit = {
    val doc = H.loadDoc("__OUTS__"); val slug = "__SLUG__"; val randomized = __RAND__
    val cases = H.items(H.field(doc, "expected"))
    var ci = 0
    while (ci < cases.length) {
      val kase = cases(ci)
      val name = H.field(kase, "name") match { case H.JStr(s) => s; case _ => "case" }
      val OPS = H.items(H.field(H.field(kase, "input"), "ops"))
      val ARG = H.items(H.field(H.field(kase, "input"), "args"))
      val AR = ARG
      val res = scala.collection.mutable.ArrayBuffer[String]()
      __CONSTRUCT__
      res += "null"
      var i = 1
      while (i < OPS.length) {
        val op = OPS(i) match { case H.JStr(s) => s; case _ => "" }
        val aa = H.items(ARG(i)); val _ = aa
__DISPATCH__
        i += 1
      }
      if (randomized) {
        val nums = H.items(H.items(ARG(0))(0))
        var j = 1
        while (j < OPS.length) { OPS(j) match { case H.JStr(s) if s == "pick" && j < res.length => res(j) = H.canonJSON(nums(res(j).toInt)); case _ => }; j += 1 }
      }
      val exp = H.items(H.field(kase, "output"))
      if (exp.length != res.length) { H.eprint(s"VALIDATE slug=$slug FAIL case=$name passed=$ci ncases=${cases.length} size exp=${exp.length} act=${res.length}\n"); System.exit(1) }
      var k = 0
      while (k < exp.length) {
        if (exp(k) != H.JNull) { val e2 = H.canonJSON(exp(k)); if (e2 != res(k)) { H.eprint(s"VALIDATE slug=$slug FAIL case=$name passed=$ci ncases=${cases.length} pos=$k expected=$e2 actual=${res(k)}\n"); System.exit(1) } }
        k += 1
      }
      ci += 1
    }
    H.eprint(s"VALIDATE slug=$slug PASS ncases=${cases.length} passed=${cases.length}\n")
    System.exit(0)
  }
}
'''
    body = (body.replace("__OUTS__", outs).replace("__SLUG__", slug).replace("__RAND__", randomized)
                .replace("__CONSTRUCT__", _design_construct(className, cnorm))
                .replace("__DISPATCH__", _design_dispatch(className, methods, fold=False)))
    return PRELUDE + body


def gen_measure_design(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    className, cnorm, methods = info["design"]
    body = r'''
object Main {
  def main(argv: Array[String]): Unit = {
    val doc = H.loadDoc("__OUTS__")
    val budget = argv(0).toDouble; val idx = argv(1).toInt
    val cases = H.items(H.field(doc, "expected"))
    val kase = cases(idx)
    val name = H.field(kase, "name") match { case H.JStr(s) => s; case _ => "case" }
    val OPS = H.items(H.field(H.field(kase, "input"), "ops"))
    val ARG = H.items(H.field(H.field(kase, "input"), "args"))
    val AR = ARG
    def replay(): Long = {
      var h: Long = 0
      __CONSTRUCT__
      var i = 1
      while (i < OPS.length) {
        val op = OPS(i) match { case H.JStr(s) => s; case _ => "" }
        val aa = H.items(ARG(i)); val _ = aa
__DISPATCH__
        i += 1
      }
      h
    }
    var acc: Long = 0; var iters: Long = 0
    val warm = budget * 0.3
    val t0 = H.nowS(); var wi = 0L
    while (H.nowS() - t0 < warm) { acc += replay(); wi += 1 }
    val per = if (wi > 0) (H.nowS() - t0) / wi.toDouble else warm
    var batch = 4096L; if (per > 0) { val bb = (0.002 / per).toLong; batch = if (bb < 1) 1 else if (bb > 4096) 4096 else bb }
    val tm = H.nowS()
    while (H.nowS() - tm < budget - warm) { var b = 0L; while (b < batch) { acc = acc * 1000003 + replay(); b += 1 }; iters += batch }
    val meas = H.nowS() - tm
    H.eprint(s"CASE=$name ITERS=$iters ACC=$acc MEAS_S=${H.fmtF(meas)} BEACON=design\n")
  }
}
'''
    body = (body.replace("__OUTS__", outs)
                .replace("__CONSTRUCT__", _design_construct(className, cnorm))
                .replace("__DISPATCH__", _design_dispatch(className, methods, fold=True)))
    return PRELUDE + body


# ── build (scalac) & run ────────────────────────────────────────────────────────
import shutil as _shutil
_SCALA_LIBS = None


def _scala_libs():
    """Discover scala3-library + scala-library jars from the toolchain so we can
    run compiled classes via plain `java` (Scala 3's `scala` runner no longer
    accepts `-cp out Main`). Returns [] if not found -> caller falls back."""
    global _SCALA_LIBS
    if _SCALA_LIBS is not None:
        return _SCALA_LIBS
    libs = []
    sc = _shutil.which("scalac") or _shutil.which("scala")
    if sc:
        d = os.path.realpath(sc)
        for _ in range(5):
            d = os.path.dirname(d)
            if not d or d == "/":
                break
            for sub in ("libexec/maven2", "libexec/lib", "lib", "maven2"):
                root = os.path.join(d, sub)
                if os.path.isdir(root):
                    for r, _dirs, fs in os.walk(root):
                        for f in fs:
                            if f.endswith(".jar") and ("scala3-library" in f or f.startswith("scala-library")):
                                libs.append(os.path.join(r, f))
            if libs:
                break
    _SCALA_LIBS = libs
    return libs


def _run_cmd(outd, extra):
    libs = _scala_libs()
    if libs:
        return ["java", "-cp", os.pathsep.join([outd] + libs), "Main"] + extra
    return ["scala", "run", "--classpath", outd, "--main-class", "Main"] + (["--"] + extra if extra else [])


def _build(slug, mode):
    info = analyze(slug)
    if info["kind"] == "unsupported":
        return None, info, info.get("reason", "unsupported")
    if info["kind"] == "design":
        src = gen_validate_design(slug, info) if mode == "validate" else gen_measure_design(slug, info)
    else:
        src = gen_validate(slug, info) if mode == "validate" else gen_measure(slug, info)
    cell = os.path.join(ROOT, "Scala", "leetcode", slug)
    sol = open(os.path.join(cell, "solution.scala")).read()
    inject = ""
    if "class TreeNode" not in sol: inject += NODES.split("class ListNode")[0]
    if "class ListNode" not in sol: inject += "\nclass ListNode" + NODES.split("class ListNode")[1]
    tmp = tempfile.mkdtemp(prefix="hz_scala_%s_" % mode)
    driver = os.path.join(tmp, "Main.scala"); open(driver, "w").write(inject + src)
    soltmp = os.path.join(tmp, "solution.scala"); open(soltmp, "w").write(sol)
    outd = os.path.join(tmp, "out"); os.makedirs(outd)
    cc = subprocess.run(["scalac", "-d", outd, soltmp, driver],
                        capture_output=True, text=True, timeout=300)
    if cc.returncode != 0:
        errs = [l for l in (cc.stderr or "").splitlines() if "error" in l.lower()]
        return None, info, "scalac: " + (errs[0] if errs else (cc.stderr or "").strip()[:200])
    return outd, info, tmp


def build_and_validate(slug):
    outd, info, tmp = _build(slug, "validate")
    if outd is None:
        sys.stderr.write("VALIDATE slug=%s ERROR %s\n" % (slug, tmp)); return 2
    cell = os.path.join(ROOT, "Scala", "leetcode", slug)
    rr = subprocess.run(_run_cmd(outd, []), capture_output=True, text=True, cwd=cell, timeout=300)
    if rr.stderr: sys.stderr.write(rr.stderr)
    return rr.returncode


def build_and_run(slug, budget, idx):
    outd, info, tmp = _build(slug, "measure")
    if outd is None:
        return "compile_error", tmp, None
    cell = os.path.join(ROOT, "Scala", "leetcode", slug)
    rr = subprocess.run(_run_cmd(outd, [str(budget), str(idx)]),
                        capture_output=True, text=True, cwd=cell, timeout=max(60, budget * 4 + 40))
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
