#!/usr/bin/env python3
"""Swift full-suite validator + perf harness for the leetcode cells.

Swift is a native toolchain (swiftc), so like harness_c / harness_rust this is a
codegen harness: it reuses harness_cpp.analyze() for the logical shape, maps
each C++ type to the deterministic LeetCode-Swift type, and emits a Swift driver
that parses the shared JSON cases, marshals them into typed Swift values, calls
`Solution().method(...)`, canonicalises the result, and compares to expected.

LeetCode Swift shape:
  * `class Solution { func method(_ a: T, ...) -> R { } }` (all params `_`-labelled)
  * design: `class Name { init(_ ...) ; func op(_ ...) -> R }`
  * nodes: `class TreeNode { var val: Int; var left/right: TreeNode? }`,
           `class ListNode { var val: Int; var next: ListNode? }`

The driver carries its own ordered, lossless JSON parser (numbers kept as raw
text) so ordering + big-int precision match the C++/C harnesses exactly.

Contract (run FROM the cell dir):
    python3 harness_swift.py validate      -> exit 0/1/3 (Accepted/WA/RE), 2 setup
    python3 harness_swift.py <budget> <idx> -> perf line on stderr
"""
import json, os, subprocess, sys, tempfile
import harness_cpp as cpp

ROOT = cpp.ROOT
REF  = cpp.REF
_UNORDERED = cpp._UNORDERED

_SCALAR = {"int": "Int", "long": "Int", "longlong": "Int",
           "double": "Double", "bool": "Bool", "char": "Character"}
_ARR = {
    "vector<int>": ("[Int]", "toIntArr"), "vector<longlong>": ("[Int]", "toIntArr"),
    "vector<long>": ("[Int]", "toIntArr"), "vector<double>": ("[Double]", "toDblArr"),
    "vector<bool>": ("[Bool]", "toBoolArr"), "vector<char>": ("[Character]", "toCharArr"),
    "vector<string>": ("[String]", "toStrArr"),
    "vector<vector<int>>": ("[[Int]]", "toIntArr2"),
    "vector<vector<double>>": ("[[Double]]", "toDblArr2"),
    "vector<vector<char>>": ("[[Character]]", "toCharArr2"),
    "vector<vector<string>>": ("[[String]]", "toStrArr2"),
}
_SCALAR_MARSHAL = {"int": "toInt", "long": "toInt", "longlong": "toInt",
                   "double": "toDbl", "bool": "toBool", "char": "toChar"}


def _swift_type(norm):
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
                        reason="Swift: design method returns/params not handled")
        return dict(kind="design", method=info["method"], design=d)
    if info["kind"] == "plain":
        norm = list(info["ptypes"]); retn = _norm_ret(info["ret"])
    else:
        norm = [_norm_ret(r) if ("TreeNode" in r or "ListNode" in r) else cpp._norm(r)
                for r in info["praw"]]
        retn = _norm_ret(info["ret"])
    for n in norm:
        if _swift_type(n) is None:
            return dict(kind="unsupported", method=info["method"],
                        reason="Swift: unhandled param type '%s'" % n)
    if _swift_type(retn) is None:
        return dict(kind="unsupported", method=info["method"],
                    reason="Swift: unhandled return type '%s'" % retn)
    return dict(kind=info["kind"], method=info["method"], ret=info["ret"],
                retn=retn, norm=norm)


# ── design ─────────────────────────────────────────────────────────────────────
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
        if retn != "void" and _swift_type(retn) is None:
            return None
        for t in cnorm + mnorm:
            if _swift_type(t) is None:
                return None
        methods.append((name, retn, mnorm))
    return className, cnorm, methods


# ── Swift prelude: nodes + JSON parser + marshal + canon ───────────────────────
NODES = """
final class TreeNode { var val: Int; var left: TreeNode?; var right: TreeNode?
  init(_ v: Int = 0) { val = v; left = nil; right = nil }
  init(_ v: Int, _ l: TreeNode?, _ r: TreeNode?) { val = v; left = l; right = r } }
final class ListNode { var val: Int; var next: ListNode?
  init(_ v: Int = 0) { val = v; next = nil }
  init(_ v: Int, _ n: ListNode?) { val = v; next = n } }
"""

PRELUDE = r"""
// NB: avoid `import Foundation` — the macOS CommandLineTools 26 / Swift 6.2
// toolchain hits "redefinition of module 'SwiftBridging'" on it. POSIX via
// Darwin/Glibc covers everything we need (file read, monotonic clock, stderr,
// %g formatting) and is portable to the Linux runner.
#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

// ---- ordered, lossless JSON (numbers kept as raw text) ----
indirect enum J { case null; case bool(Bool); case num(String); case str(String)
                  case arr([J]); case obj([(String, J)]) }
struct JP {
    let s: [Character]; var p = 0
    init(_ t: String) { s = Array(t) }
    mutating func ws() { while p < s.count, s[p] == " " || s[p] == "\n" || s[p] == "\t" || s[p] == "\r" { p += 1 } }
    mutating func value() -> J {
        ws(); let c = s[p]
        if c == "{" { return objv() }
        if c == "[" { return arrv() }
        if c == "\"" { return .str(strv()) }
        if c == "t" { p += 4; return .bool(true) }
        if c == "f" { p += 5; return .bool(false) }
        if c == "n" { p += 4; return .null }
        return numv()
    }
    mutating func strv() -> String {
        var b = ""; p += 1
        while p < s.count {
            let c = s[p]; p += 1
            if c == "\"" { break }
            if c == "\\" {
                let e = s[p]; p += 1
                switch e {
                case "n": b += "\n"; case "t": b += "\t"; case "r": b += "\r"
                case "b": b += "\u{08}"; case "f": b += "\u{0C}"; case "/": b += "/"
                case "\"": b += "\""; case "\\": b += "\\"
                case "u":
                    let hex = String(s[p..<p+4]); p += 4
                    if let cp = UInt32(hex, radix: 16), let sc = Unicode.Scalar(cp) { b.unicodeScalars.append(sc) }
                default: b.append(e)
                }
            } else { b.append(c) }
        }
        return b
    }
    mutating func numv() -> J {
        let st = p
        while p < s.count, ("0"..."9").contains(s[p]) || "+-.eE".contains(s[p]) { p += 1 }
        return .num(String(s[st..<p]))
    }
    mutating func arrv() -> J {
        var v = [J](); p += 1; ws()
        if s[p] == "]" { p += 1; return .arr(v) }
        while true { v.append(value()); ws(); if s[p] == "," { p += 1; continue }; p += 1; break }
        return .arr(v)
    }
    mutating func objv() -> J {
        var v = [(String, J)](); p += 1; ws()
        if s[p] == "}" { p += 1; return .obj(v) }
        while true { ws(); let k = strv(); ws(); p += 1; v.append((k, value())); ws()
            if s[p] == "," { p += 1; continue }; p += 1; break }
        return .obj(v)
    }
}
func field(_ j: J, _ k: String) -> J? { if case .obj(let o) = j { for kv in o where kv.0 == k { return kv.1 } }; return nil }
func items(_ j: J) -> [J] { if case .arr(let a) = j { return a }; return [] }
func entries(_ j: J) -> [(String, J)] { if case .obj(let o) = j { return o }; return [] }

// ---- marshal J -> typed ----
func toInt(_ j: J) -> Int { if case .num(let r) = j { return Int(r) ?? Int(Double(r) ?? 0) }; if case .bool(let b) = j { return b ? 1 : 0 }; return 0 }
func toDbl(_ j: J) -> Double { if case .num(let r) = j { return Double(r) ?? 0 }; return 0 }
func toBool(_ j: J) -> Bool { if case .bool(let b) = j { return b }; return toInt(j) != 0 }
func toStr(_ j: J) -> String { if case .str(let s) = j { return s }; return "" }
func toChar(_ j: J) -> Character { let s = toStr(j); return s.first ?? " " }
func toIntArr(_ j: J) -> [Int] { items(j).map(toInt) }
func toDblArr(_ j: J) -> [Double] { items(j).map(toDbl) }
func toBoolArr(_ j: J) -> [Bool] { items(j).map(toBool) }
func toStrArr(_ j: J) -> [String] { items(j).map(toStr) }
func toCharArr(_ j: J) -> [Character] { items(j).map(toChar) }
func toIntArr2(_ j: J) -> [[Int]] { items(j).map(toIntArr) }
func toDblArr2(_ j: J) -> [[Double]] { items(j).map(toDblArr) }
func toCharArr2(_ j: J) -> [[Character]] { items(j).map(toCharArr) }
func toStrArr2(_ j: J) -> [[String]] { items(j).map(toStrArr) }
func toTree(_ j: J) -> TreeNode? {
    let a = items(j); if a.isEmpty { return nil }
    if case .null = a[0] { return nil }
    let root = TreeNode(toInt(a[0])); var q = [root]; var qi = 0; var i = 1
    while i < a.count, qi < q.count {
        let n = q[qi]; qi += 1
        if i < a.count { if case .null = a[i] {} else { n.left = TreeNode(toInt(a[i])); q.append(n.left!) }; i += 1 }
        if i < a.count { if case .null = a[i] {} else { n.right = TreeNode(toInt(a[i])); q.append(n.right!) }; i += 1 }
    }
    return root
}
func toList(_ j: J) -> ListNode? {
    let a = items(j); if a.isEmpty { return nil }
    let head = ListNode(toInt(a[0])); var cur = head
    for i in 1..<a.count { cur.next = ListNode(toInt(a[i])); cur = cur.next! }
    return head
}
func listVals(_ n: ListNode?) -> [Int] { var r = [Int](); var c = n; while c != nil { r.append(c!.val); c = c!.next }; return r }
func treeVals(_ r: TreeNode?) -> [Int] { var o = [Int](); var q = [TreeNode](); if let r = r { q.append(r) }; var i = 0
    while i < q.count { let n = q[i]; i += 1; o.append(n.val); if let l = n.left { q.append(l) }; if let rr = n.right { q.append(rr) } }; return o }

// ---- canon (matches the C++/C harness textual form) ----
func q(_ s: String) -> String { var o = "\""; for c in s { if c == "\"" || c == "\\" { o.append("\\") }; o.append(c) }; o += "\""; return o }
protocol CV { var cv: String { get } }
extension Int: CV { var cv: String { String(self) } }
extension Bool: CV { var cv: String { self ? "true" : "false" } }
extension Double: CV { var cv: String { if isFinite && self == rounded() && abs(self) < 9.007199254740992e15 { return String(Int(self)) }; return fmtG(self) } }
extension String: CV { var cv: String { q(self) } }
extension Character: CV { var cv: String { q(String(self)) } }
extension Array: CV where Element: CV { var cv: String { "[" + map { $0.cv }.joined(separator: ",") + "]" } }
func mset<T: CV>(_ a: [T]) -> String { "[" + a.map { $0.cv }.sorted().joined(separator: ",") + "]" }
func canonJSON(_ j: J) -> String {
    switch j {
    case .null: return "null"
    case .bool(let b): return b ? "true" : "false"
    case .str(let s): return q(s)
    case .num(let r):
        if r.contains(".") || r.contains("e") || r.contains("E") {
            let d = Double(r) ?? 0
            if d.isFinite && d == d.rounded() && abs(d) < 9.007199254740992e15 { return String(Int(d)) }
            return fmtG(d)
        }
        return String(Int(r) ?? 0)
    case .arr(let a): return "[" + a.map { canonJSON($0) }.joined(separator: ",") + "]"
    case .obj: return "null"
    }
}
func canonJSONmset(_ j: J) -> String {
    if case .arr(let a) = j { return "[" + a.map { canonJSON($0) }.sorted().joined(separator: ",") + "]" }
    return canonJSON(j)
}
func eprint(_ s: String) { fputs(s, stderr) }
func fmtG(_ d: Double) -> String { var b = [CChar](repeating: 0, count: 64); snprintf(ptr: &b, 64, "%.6g", d); return String(cString: b) }
func fmtF6(_ d: Double) -> String { var b = [CChar](repeating: 0, count: 64); snprintf(ptr: &b, 64, "%.6f", d); return String(cString: b) }
func nowS() -> Double { var ts = timespec(); clock_gettime(CLOCK_MONOTONIC, &ts); return Double(ts.tv_sec) + Double(ts.tv_nsec) / 1e9 }
func readFile(_ path: String) -> String {
    guard let fp = fopen(path, "r") else { return "" }
    defer { fclose(fp) }
    var data = [UInt8](); var buf = [UInt8](repeating: 0, count: 65536)
    while true { let n = fread(&buf, 1, buf.count, fp); if n <= 0 { break }; data.append(contentsOf: buf[0..<n]) }
    return String(decoding: data, as: UTF8.self)
}
func loadDoc(_ path: String) -> J { var p = JP(readFile(path)); return p.value() }
"""


def _prelude(info):
    kind = info["kind"]
    if kind == "design":
        uses_tree = uses_list = False
        for _o, _r, mn in info["design"][2]:
            uses_tree = uses_tree or "TreeNode*" in mn
            uses_list = uses_list or "ListNode*" in mn
    else:
        uses_tree = "TreeNode*" in info["norm"] or info["retn"] == "TreeNode*"
        uses_list = "ListNode*" in info["norm"] or info["retn"] == "ListNode*"
    # NODES go in the driver unless the solution defines them (checked at build).
    return PRELUDE, (uses_tree, uses_list)


# ── arg marshalling ────────────────────────────────────────────────────────────
def _marshal_call(norm, srcexpr):
    """Return the call-arg expressions marshalling srcexpr(i) -> Swift value."""
    args = []
    for i, n in enumerate(norm):
        src = srcexpr(i)
        if n in _SCALAR:      args.append("%s(%s)" % (_SCALAR_MARSHAL[n], src))
        elif n == "string":   args.append("toStr(%s)" % src)
        elif n in _ARR:       args.append("%s(%s)" % (_ARR[n][1], src))
        elif n == "TreeNode*": args.append("toTree(%s)" % src)
        elif n == "ListNode*": args.append("toList(%s)" % src)
        else: raise ValueError(n)
    return args


def _canon_result(retn, callexpr):
    if retn == "ListNode*": return "listVals(%s).cv" % callexpr
    if retn == "TreeNode*": return "treeVals(%s).cv" % callexpr
    return "(%s).cv" % callexpr


# ── validate / measure mains ───────────────────────────────────────────────────
def gen_validate(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    args = _marshal_call(info["norm"], lambda i: "E[%d].1" % i)
    call = "Solution().%s(%s)" % (info["method"], ", ".join(args))
    unordered = slug in _UNORDERED
    if unordered and info["retn"] in _ARR:
        actual = "mset(%s)" % call
        exp = "canonJSONmset(outV)"
    else:
        actual = _canon_result(info["retn"], call)
        exp = "canonJSON(outV)"
    body = r'''
let doc = loadDoc("__OUTS__")
let slug = "__SLUG__"
let cases = items(field(doc, "expected")!)
for (ci, kase) in cases.enumerated() {
    let name = { if case .str(let s)? = field(kase, "name") { return s }; return "case" }()
    let E = entries(field(kase, "input")!)
    _ = E
    let outV = field(kase, "output") ?? .null
    let actual = __ACTUAL__
    let exp = __EXP__
    if exp != actual {
        eprint("VALIDATE slug=\(slug) FAIL case=\(name) passed=\(ci) ncases=\(cases.count) expected=\(String(exp.prefix(120))) actual=\(String(actual.prefix(120)))\n")
        exit(1)
    }
}
eprint("VALIDATE slug=\(slug) PASS ncases=\(cases.count) passed=\(cases.count)\n")
exit(0)
'''
    body = (body.replace("__OUTS__", outs).replace("__SLUG__", slug)
                .replace("__ACTUAL__", actual).replace("__EXP__", exp))
    return PRELUDE + body


def gen_measure(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    args = _marshal_call(info["norm"], lambda i: "E[%d].1" % i)
    call = "Solution().%s(%s)" % (info["method"], ", ".join(args))
    beacon = _canon_result(info["retn"], call)
    body = r'''
let doc = loadDoc("__OUTS__")
let budget = Double(CommandLine.arguments[1]) ?? 1.0
let idx = Int(CommandLine.arguments[2]) ?? 0
let cases = items(field(doc, "expected")!)
let kase = cases[idx]
let name = { if case .str(let s)? = field(kase, "name") { return s }; return "case" }()
let E = entries(field(kase, "input")!)
_ = E
func doCall() -> String { return __BEACON__ }
var acc: UInt64 = 0; var iters = 0
let warm = budget * 0.3
let t0 = nowS(); var wi = 0
while nowS() - t0 < warm { _ = doCall(); wi += 1 }
let per = wi > 0 ? (nowS() - t0) / Double(wi) : warm
var batch = 4096; if per > 0 { let bb = Int(0.002 / per); batch = bb < 1 ? 1 : (bb > 4096 ? 4096 : bb) }
let tm = nowS()
while nowS() - tm < budget - warm { for _ in 0..<batch { for b in doCall().utf8 { acc = acc &* 1000003 &+ UInt64(b) } }; iters += batch }
let meas = nowS() - tm
let beacon = doCall()
eprint("CASE=\(name) ITERS=\(iters) ACC=\(acc) MEAS_S=\(fmtF6(meas)) BEACON=\(beacon)\n")
'''
    body = body.replace("__OUTS__", outs).replace("__BEACON__", beacon)
    return PRELUDE + body


# ── design mains ────────────────────────────────────────────────────────────────
def _design_construct(className, cnorm):
    args = _marshal_call(cnorm, lambda i: "AR[0].arr()[%d]" % i)
    # AR[0] is the ctor-args array
    return "var obj = %s(%s)" % (className, ", ".join(args))


def _design_dispatch(className, methods):
    # returns a Swift switch over op -> call, appending to results
    lines = []
    for op, retn, mnorm in methods:
        margs = _marshal_call(mnorm, lambda i: "aa[%d]" % i)
        callexpr = "obj.%s(%s)" % (op, ", ".join(margs))
        if retn == "void":
            lines.append('        if op == "%s" { %s; if rec { res.append("null") } }' % (op, callexpr))
        else:
            lines.append('        if op == "%s" { let rv = %s; if rec { res.append((rv).cv) } }' % (op, callexpr))
    return "\n".join(lines)


def _arr_ext():
    # helper: J.arr() accessor used by design (args arrays)
    return "\nextension J { func arr() -> [J] { items(self) } }\n"


def gen_validate_design(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    className, cnorm, methods = info["design"]
    randomized = "true" if slug == "random-pick-index" else "false"
    body = r'''
let doc = loadDoc("__OUTS__")
let slug = "__SLUG__"
let randomized = __RAND__
let cases = items(field(doc, "expected")!)
for (ci, kase) in cases.enumerated() {
    let name = { if case .str(let s)? = field(kase, "name") { return s }; return "case" }()
    let OPS = items(field(kase, "input")!.arrField("ops"))
    let ARG = items(field(kase, "input")!.arrField("args"))
    let AR = ARG
    var res = [String](); let rec = true
    __CONSTRUCT__
    res.append("null")
    for i in 1..<OPS.count {
        let op: String = { if case .str(let s) = OPS[i] { return s }; return "" }()
        let aa = items(ARG[i])
        _ = aa
__DISPATCH__
    }
    if randomized {
        let nums = items(items(ARG[0])[0])
        for i in 1..<OPS.count { if case .str(let s) = OPS[i], s == "pick", i < res.count { res[i] = canonJSON(nums[Int(res[i]) ?? 0]) } }
    }
    let exp = items(field(kase, "output") ?? .null)
    if exp.count != res.count {
        eprint("VALIDATE slug=\(slug) FAIL case=\(name) passed=\(ci) ncases=\(cases.count) size exp=\(exp.count) act=\(res.count)\n"); exit(1)
    }
    for i in 0..<exp.count {
        if case .null = exp[i] { continue }
        let e2 = canonJSON(exp[i])
        if e2 != res[i] {
            eprint("VALIDATE slug=\(slug) FAIL case=\(name) passed=\(ci) ncases=\(cases.count) pos=\(i) expected=\(e2) actual=\(res[i])\n"); exit(1)
        }
    }
}
eprint("VALIDATE slug=\(slug) PASS ncases=\(cases.count) passed=\(cases.count)\n")
exit(0)
'''
    body = (body.replace("__OUTS__", outs).replace("__SLUG__", slug).replace("__RAND__", randomized)
                .replace("__CONSTRUCT__", _design_construct(className, cnorm))
                .replace("__DISPATCH__", _design_dispatch(className, methods)))
    return PRELUDE + _design_helpers() + body


def gen_measure_design(slug, info):
    outs = os.path.join(REF, "outputs", slug + ".json")
    className, cnorm, methods = info["design"]
    body = r'''
let doc = loadDoc("__OUTS__")
let budget = Double(CommandLine.arguments[1]) ?? 1.0
let idx = Int(CommandLine.arguments[2]) ?? 0
let cases = items(field(doc, "expected")!)
let kase = cases[idx]
let name = { if case .str(let s)? = field(kase, "name") { return s }; return "case" }()
let OPS = items(field(kase, "input")!.arrField("ops"))
let ARG = items(field(kase, "input")!.arrField("args"))
let AR = ARG
func replay() -> UInt64 {
    var h: UInt64 = 0
    var res = [String](); let rec = false; _ = res
    __CONSTRUCT__
    for i in 1..<OPS.count {
        let op: String = { if case .str(let s) = OPS[i] { return s }; return "" }()
        let aa = items(ARG[i]); _ = aa
__DISPATCH__
    }
    return h
}
var acc: UInt64 = 0; var iters = 0
let warm = budget * 0.3
let t0 = nowS(); var wi = 0
while nowS() - t0 < warm { acc = acc &+ replay(); wi += 1 }
let per = wi > 0 ? (nowS() - t0) / Double(wi) : warm
var batch = 4096; if per > 0 { let bb = Int(0.002 / per); batch = bb < 1 ? 1 : (bb > 4096 ? 4096 : bb) }
let tm = nowS()
while nowS() - tm < budget - warm { for _ in 0..<batch { acc = acc &* 1000003 &+ replay() }; iters += batch }
let meas = nowS() - tm
eprint("CASE=\(name) ITERS=\(iters) ACC=\(acc) MEAS_S=\(fmtF6(meas)) BEACON=design\n")
'''
    # design measure folds a checksum; reuse dispatch but into h
    dispatch = []
    for op, retn, mnorm in methods:
        margs = _marshal_call(mnorm, lambda i: "aa[%d]" % i)
        callexpr = "obj.%s(%s)" % (op, ", ".join(margs))
        if retn == "void":
            dispatch.append('        if op == "%s" { %s; h = h &* 1000003 &+ 3 }' % (op, callexpr))
        else:
            dispatch.append('        if op == "%s" { let rv = %s; h = h &* 1000003 &+ UInt64(bitPattern: Int64(csInt(rv))) }' % (op, callexpr))
    body = (body.replace("__OUTS__", outs)
                .replace("__CONSTRUCT__", _design_construct(className, cnorm))
                .replace("__DISPATCH__", "\n".join(dispatch)))
    return PRELUDE + _design_helpers() + body


def _design_helpers():
    return (_arr_ext() +
            "\nextension J { func arrField(_ k: String) -> J { field(self, k) ?? .arr([]) } }\n"
            "func csInt(_ x: Int) -> Int { x }\nfunc csInt(_ x: Bool) -> Int { x ? 1 : 0 }\n"
            "func csInt(_ x: Double) -> Int { Int(x * 1e6) }\n")


# ── build (swiftc) & run ────────────────────────────────────────────────────────
def _build(slug, mode):
    info = analyze(slug)
    if info["kind"] == "unsupported":
        return None, info, info.get("reason", "unsupported")
    if info["kind"] == "design":
        src = gen_validate_design(slug, info) if mode == "validate" else gen_measure_design(slug, info)
    else:
        src = gen_validate(slug, info) if mode == "validate" else gen_measure(slug, info)
    cell = os.path.join(ROOT, "Swift", "leetcode", slug)
    sol = open(os.path.join(cell, "solution.swift")).read()
    # The marshal helpers (toTree/toList/…) always reference TreeNode/ListNode,
    # so both must be in scope. LeetCode Swift solutions don't define them (the
    # judge provides them), so inject both — unless the model defined them.
    treedef = NODES.split("final class ListNode")[0]
    listdef = "\nfinal class ListNode" + NODES.split("final class ListNode")[1]
    inject = ""
    if "class TreeNode" not in sol: inject += treedef
    if "class ListNode" not in sol: inject += listdef
    tmp = tempfile.mkdtemp(prefix="hz_swift_%s_" % mode)
    # top-level executable code must live in a file called main.swift
    driver = os.path.join(tmp, "main.swift")
    open(driver, "w").write(inject + src)
    soltmp = os.path.join(tmp, "solution.swift"); open(soltmp, "w").write(sol)
    binp = os.path.join(tmp, "driver")
    cc = subprocess.run(["swiftc", "-O", driver, soltmp, "-o", binp],
                        capture_output=True, text=True)
    if cc.returncode != 0:
        # surface the first real "error:" line, not swiftc's source-context tail
        errs = [l for l in (cc.stderr or "").splitlines() if " error: " in l]
        return None, info, "swiftc: " + (errs[0] if errs else (cc.stderr or "").strip()[:200])
    return binp, info, tmp


def build_and_validate(slug):
    binp, info, tmp = _build(slug, "validate")
    if binp is None:
        sys.stderr.write("VALIDATE slug=%s ERROR %s\n" % (slug, tmp))
        return 2
    cell = os.path.join(ROOT, "Swift", "leetcode", slug)
    rr = subprocess.run([binp], capture_output=True, text=True, cwd=cell, timeout=300)
    if rr.stderr: sys.stderr.write(rr.stderr)
    return rr.returncode


def build_and_run(slug, budget, idx):
    binp, info, tmp = _build(slug, "measure")
    if binp is None:
        return "compile_error", tmp, None
    cell = os.path.join(ROOT, "Swift", "leetcode", slug)
    rr = subprocess.run([binp, str(budget), str(idx)], capture_output=True, text=True,
                        cwd=cell, timeout=max(30, budget * 4 + 20))
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
