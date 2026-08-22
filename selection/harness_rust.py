#!/usr/bin/env python3
# Generic Rust loop-harness for the cross-language transfer check.
#
# Rust has NO runtime reflection, so we cannot dispatch a call generically the
# way the Java/JS harnesses do. Instead this script GENERATES a tiny per-problem
# driver from the Solution method's *signature*: it parses the entry method's
# Rust parameter types and emits, for each parameter, a marshalling EXPRESSION
# that turns the shared JSON input (expected[idx].input) into the exact Rust type
# (Vec<i32>, String, Vec<Vec<i32>>, char, i64, f64, ...). Crucially the JSON is
# parsed and marshalled AT RUNTIME by a small std-only JSON reader embedded in the
# driver (mirroring harness_cpp.py's hz::JVal / hz::JP) -- the input is never baked
# into the source as literals, so COMPILE TIME IS INDEPENDENT OF INPUT SIZE. It
# emits a `fn main()` that rebuilds fresh args each iteration, calls
# `Solution::method(...)`, and loops to a wall-time budget folding each result's
# canonical string into a checksum. Every call site wraps its args AND the result
# in `std::hint::black_box(...)` so the optimizer cannot hoist / const-fold / DCE
# the loop body. The driver is concatenated after solution.rs (with a `pub struct
# Solution;` header prepended when the solution doesn't declare one, mirroring the
# existing Rust cell Makefiles) and compiled with `rustc -O`.
#
#   python3 harness_rust.py <budget_seconds> <case_index>   (run from the Rust cell dir)
#   - slug derived from cwd basename (Rust/leetcode/<slug>/)
#   - the driver reads ../../../reference/leetcode/outputs/<slug>.json at RUNTIME
#     (slug derived from std::env::current_dir()), just like the C++/Java/Go harnesses
#   - the compiled binary prints CASE/ITERS/ACC/MEAS_S/BEACON to STDERR (stdout empty)
#   - set env HARNESS_EMIT_RESULT=1 to also print the full case canonical result
#     to stdout (used only by the correctness verifier; real runs leave stdout empty)
#
# Three input shapes are handled by dedicated codegen paths, all mirroring the
# SEMANTICS of Harness.java (buildTree/buildList/replay/canon):
#   * plain-data method calls (Vec/String/scalar args)
#   * tree (Option<Rc<RefCell<TreeNode>>>) and linked-list (Option<Box<ListNode>>)
#     entry methods: args built from level-order/array input; list results are
#     serialized back to a JSON int array for the BEACON.
#   * design classes (input {ops,args}): each iteration re-instantiates the struct
#     (ops[0]=::new with args[0]) and replays ops[i]/args[i], folding each return.

import json
import os
import re
import subprocess
import sys
import tempfile

RUSTC = os.environ.get("RUSTC", "rustc")

# Problems LeetCode judges order-insensitively (special judge): multiset compare.
_UNORDERED = {"uncommon-words-from-two-sentences", "remove-invalid-parentheses",
              "restore-the-array-from-adjacent-pairs"}


def norm(s):
    return "".join(c.lower() for c in s if c.isalnum())


INT_TYPES = {"i8", "i16", "i32", "i64", "i128", "isize",
             "u8", "u16", "u32", "u64", "u128", "usize"}


def marshal_expr(typ, jref):
    """Rust EXPRESSION of exact type `typ` produced from a `&JVal` expression `jref`
    at runtime. Mirrors harness_cpp.py's to_* marshallers. `jref` is any Rust
    expression evaluating to `&JVal` (e.g. `&ev[0].1`, `&aa.as_arr()[2]`)."""
    t = typ.strip()
    if t in INT_TYPES:
        return f"(({jref}).as_i64() as {t})"
    if t == "f32":
        return f"(({jref}).as_f64() as f32)"
    if t == "f64":
        return f"({jref}).as_f64()"
    if t == "bool":
        return f"({jref}).as_bool()"
    if t == "char":
        # LeetCode design classes sometimes pass a length-1 string where the
        # Rust signature takes a char (e.g. StreamChecker::query).
        return f"({jref}).as_char()"
    if t == "String":
        return f"({jref}).as_str().to_string()"
    if t == "&str":
        return f"({jref}).as_str()"
    if t.startswith("Vec<") and t.endswith(">"):
        inner = t[4:-1].strip()
        elem = marshal_expr(inner, "__e")
        return (f"({jref}).as_arr().iter().map(|__e| {elem})"
                f".collect::<Vec<{inner}>>()")
    raise ValueError(f"unsupported type: {typ!r}")


def split_top(s, sep=","):
    parts, depth, cur = [], 0, ""
    for c in s:
        if c in "<([":
            depth += 1
        elif c in ">)]":
            depth -= 1
        if c == sep and depth == 0:
            parts.append(cur)
            cur = ""
        else:
            cur += c
    if cur.strip():
        parts.append(cur)
    return [p.strip() for p in parts if p.strip()]


def parse_param(part):
    name, typ = part.split(":", 1)
    name = name.strip()
    if name.startswith("mut "):
        name = name[4:].strip()
    return name, typ.strip()


def _fn_params_ret(src, m):
    """Given a regex match `m` at `fn <name>(`, return (params_str, ret)."""
    i = m.end() - 1  # index of '('
    depth, j = 0, i
    while j < len(src):
        c = src[j]
        if c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
            if depth == 0:
                break
        j += 1
    params_str = src[i + 1:j]
    brace = src.find("{", j)
    between = src[j + 1:brace] if brace != -1 else src[j + 1:]
    ret = between.split("->", 1)[1].strip() if "->" in between else "()"
    return params_str, ret


def find_signature(src, method_norm):
    """Return (name, [(pname,ptype),...], ret_type) for the fn whose name
    normalizes to method_norm, else None. (Associated fns, no self receiver.)"""
    for m in re.finditer(r"\bfn\s+([A-Za-z0-9_]+)\s*\(", src):
        name = m.group(1)
        if norm(name) != method_norm:
            continue
        params_str, ret = _fn_params_ret(src, m)
        params = [parse_param(p) for p in split_top(params_str)]
        return name, params, ret
    return None


def parse_method_params(params_str):
    """Params of a method, dropping a leading self receiver (&self/&mut self/self)."""
    out = []
    for p in split_top(params_str):
        if ":" not in p:  # receiver token: self, &self, &mut self
            continue
        name, typ = p.split(":", 1)
        name = name.strip()
        if name.startswith("mut "):
            name = name[4:].strip()
        out.append((name, typ.strip()))
    return out


def find_method(src, method_norm, argc):
    """Return (name, [(pname,ptype),...non-self], ret) for a method whose name
    normalizes to method_norm, preferring the overload with `argc` args."""
    cands = []
    for m in re.finditer(r"\bfn\s+([A-Za-z0-9_]+)\s*\(", src):
        name = m.group(1)
        if norm(name) != method_norm:
            continue
        params_str, ret = _fn_params_ret(src, m)
        cands.append((name, parse_method_params(params_str), ret))
    for c in cands:
        if len(c[1]) == argc:
            return c
    return cands[0] if cands else None


# ---------------------------------------------------------------------------
# Embedded std-only JSON reader (mirrors harness_cpp.py's hz::JVal / hz::JP).
# Numbers are kept as raw text so int/float marshalling is lossless. Parsing is
# a fixed-size chunk of code, so compile time does not scale with the input.
# ---------------------------------------------------------------------------

JSON_MOD = r'''
// ---- embedded JSON reader (std-only; produced by harness_rust.py) ----
#[derive(Clone)]
enum JVal {
    Null,
    Bool(bool),
    Num(String),
    Str(String),
    Arr(Vec<JVal>),
    Obj(Vec<(String, JVal)>),
}
#[allow(dead_code)]
impl JVal {
    fn is_null(&self) -> bool { matches!(self, JVal::Null) }
    fn as_i64(&self) -> i64 {
        match self {
            JVal::Num(s) => s.parse::<i64>()
                .unwrap_or_else(|_| s.parse::<f64>().unwrap_or(0.0) as i64),
            JVal::Bool(b) => if *b { 1 } else { 0 },
            _ => 0,
        }
    }
    fn as_f64(&self) -> f64 {
        match self { JVal::Num(s) => s.parse::<f64>().unwrap_or(0.0), _ => 0.0 }
    }
    fn as_bool(&self) -> bool {
        match self {
            JVal::Bool(b) => *b,
            JVal::Num(_) => self.as_i64() != 0,
            _ => false,
        }
    }
    fn as_str(&self) -> &str {
        match self { JVal::Str(s) => s.as_str(), _ => "" }
    }
    fn as_char(&self) -> char {
        match self { JVal::Str(s) => s.chars().next().unwrap_or('\u{0}'), _ => '\u{0}' }
    }
    fn as_arr(&self) -> &[JVal] {
        match self { JVal::Arr(a) => a.as_slice(), _ => &[] }
    }
    fn as_obj(&self) -> &[(String, JVal)] {
        match self { JVal::Obj(o) => o.as_slice(), _ => &[] }
    }
    fn field(&self, k: &str) -> &JVal {
        if let JVal::Obj(o) = self {
            for (kk, vv) in o { if kk == k { return vv; } }
        }
        panic!("missing JSON field {:?}", k);
    }
}

struct JP<'a> { b: &'a [u8], p: usize }
impl<'a> JP<'a> {
    fn new(s: &'a str) -> Self { JP { b: s.as_bytes(), p: 0 } }
    fn ws(&mut self) {
        while self.p < self.b.len() && self.b[self.p].is_ascii_whitespace() { self.p += 1; }
    }
    fn val(&mut self) -> JVal {
        self.ws();
        match self.b[self.p] {
            b'{' => self.objj(),
            b'[' => self.arrj(),
            b'"' => JVal::Str(self.strj()),
            b't' => { self.p += 4; JVal::Bool(true) }
            b'f' => { self.p += 5; JVal::Bool(false) }
            b'n' => { self.p += 4; JVal::Null }
            _ => self.numj(),
        }
    }
    fn strj(&mut self) -> String {
        let mut out: Vec<u8> = Vec::new();
        self.p += 1; // opening quote
        while self.p < self.b.len() {
            let c = self.b[self.p]; self.p += 1;
            if c == b'"' { break; }
            if c == b'\\' {
                let e = self.b[self.p]; self.p += 1;
                match e {
                    b'n' => out.push(b'\n'),
                    b't' => out.push(b'\t'),
                    b'r' => out.push(b'\r'),
                    b'b' => out.push(8),
                    b'f' => out.push(12),
                    b'/' => out.push(b'/'),
                    b'"' => out.push(b'"'),
                    b'\\' => out.push(b'\\'),
                    b'u' => {
                        let hex = std::str::from_utf8(&self.b[self.p..self.p + 4]).unwrap_or("0000");
                        let cp = u32::from_str_radix(hex, 16).unwrap_or(0);
                        self.p += 4;
                        if cp < 128 { out.push(cp as u8); }
                        else {
                            let mut buf = [0u8; 4];
                            let s = char::from_u32(cp).unwrap_or('?').encode_utf8(&mut buf);
                            out.extend_from_slice(s.as_bytes());
                        }
                    }
                    _ => out.push(e),
                }
            } else {
                out.push(c);
            }
        }
        String::from_utf8_lossy(&out).into_owned()
    }
    fn numj(&mut self) -> JVal {
        let st = self.p;
        while self.p < self.b.len() {
            let c = self.b[self.p];
            if c.is_ascii_digit() || c == b'+' || c == b'-' || c == b'.' || c == b'e' || c == b'E' {
                self.p += 1;
            } else { break; }
        }
        JVal::Num(std::str::from_utf8(&self.b[st..self.p]).unwrap_or("0").to_string())
    }
    fn arrj(&mut self) -> JVal {
        let mut a: Vec<JVal> = Vec::new();
        self.p += 1; self.ws();
        if self.b[self.p] == b']' { self.p += 1; return JVal::Arr(a); }
        loop {
            a.push(self.val()); self.ws();
            if self.b[self.p] == b',' { self.p += 1; continue; }
            self.p += 1; break;
        }
        JVal::Arr(a)
    }
    fn objj(&mut self) -> JVal {
        let mut o: Vec<(String, JVal)> = Vec::new();
        self.p += 1; self.ws();
        if self.b[self.p] == b'}' { self.p += 1; return JVal::Obj(o); }
        loop {
            self.ws();
            let k = self.strj(); self.ws();
            self.p += 1; // skip ':'
            let v = self.val();
            o.push((k, v)); self.ws();
            if self.b[self.p] == b',' { self.p += 1; continue; }
            self.p += 1; break;
        }
        JVal::Obj(o)
    }
}

fn __load() -> JVal {
    let cwd = std::env::current_dir().expect("current_dir");
    let slug = cwd.file_name().map(|s| s.to_string_lossy().into_owned()).unwrap_or_default();
    let path = cwd.join("../../../reference/leetcode/outputs")
        .join(format!("{}.json", slug));
    let text = std::fs::read_to_string(&path)
        .unwrap_or_else(|e| panic!("read {:?}: {}", path, e));
    JP::new(&text).val()
}
'''

# ---------------------------------------------------------------------------
# Structure definitions + builders/canonicalizers (mirror Harness.java)
# ---------------------------------------------------------------------------

TREE_DEF = """#[derive(Debug, PartialEq, Eq)]
pub struct TreeNode {
    pub val: i32,
    pub left: Option<std::rc::Rc<std::cell::RefCell<TreeNode>>>,
    pub right: Option<std::rc::Rc<std::cell::RefCell<TreeNode>>>,
}
impl TreeNode {
    #[inline]
    pub fn new(val: i32) -> Self {
        TreeNode { val, left: None, right: None }
    }
}
"""

LIST_DEF = """#[derive(Debug, PartialEq, Eq, Clone)]
pub struct ListNode {
    pub val: i32,
    pub next: Option<Box<ListNode>>,
}
impl ListNode {
    #[inline]
    pub fn new(val: i32) -> Self {
        ListNode { next: None, val }
    }
}
"""

BUILD_TREE_FN = """fn __build_tree(l: &[Option<i32>]) -> Option<std::rc::Rc<std::cell::RefCell<TreeNode>>> {
    if l.is_empty() { return None; }
    let root_val = match l[0] { Some(v) => v, None => return None };
    let root = std::rc::Rc::new(std::cell::RefCell::new(TreeNode::new(root_val)));
    let mut q: std::collections::VecDeque<std::rc::Rc<std::cell::RefCell<TreeNode>>> =
        std::collections::VecDeque::new();
    q.push_back(std::rc::Rc::clone(&root));
    let mut i = 1usize;
    while i < l.len() {
        let node = match q.pop_front() { Some(n) => n, None => break };
        if i < l.len() {
            if let Some(v) = l[i] {
                let child = std::rc::Rc::new(std::cell::RefCell::new(TreeNode::new(v)));
                node.borrow_mut().left = Some(std::rc::Rc::clone(&child));
                q.push_back(child);
            }
            i += 1;
        }
        if i < l.len() {
            if let Some(v) = l[i] {
                let child = std::rc::Rc::new(std::cell::RefCell::new(TreeNode::new(v)));
                node.borrow_mut().right = Some(std::rc::Rc::clone(&child));
                q.push_back(child);
            }
            i += 1;
        }
    }
    Some(root)
}
"""

BUILD_LIST_FN = """fn __build_list(a: &[i32]) -> Option<Box<ListNode>> {
    let mut head: Option<Box<ListNode>> = None;
    for &v in a.iter().rev() {
        let mut node = Box::new(ListNode::new(v));
        node.next = head.take();
        head = Some(node);
    }
    head
}
"""

CANON_LIST_FN = """fn __canon_list(head: &Option<Box<ListNode>>) -> String {
    let mut out = String::from("[");
    let mut p = head;
    let mut first = true;
    while let Some(n) = p {
        if !first { out.push(','); }
        out.push_str(&n.val.to_string());
        first = false;
        p = &n.next;
    }
    out.push(']');
    out
}
"""

HASH_FN = """fn __hash(s: &str, acc: &mut u64) {
    for b in s.bytes() {
        *acc = acc.wrapping_mul(1099511628211u64).wrapping_add(b as u64);
    }
}
"""

# Allocation-free fold: hash the result value directly (std::hash::Hash) instead
# of building a canonical String every measured iteration. Only emitted for
# Hash-able return types (see ret_hashable); float-containing / node results keep
# the string path. ACC is never compared across A/B, so any deterministic fold is
# fine here; the point is to kill the per-iteration String allocation.
HFOLD_FN = """#[inline]
fn __hfold<T: std::hash::Hash>(v: &T, acc: &mut u64) {
    use std::hash::Hasher;
    let mut hh = std::collections::hash_map::DefaultHasher::new();
    std::hash::Hash::hash(v, &mut hh);
    *acc = acc.wrapping_mul(1000003).wrapping_add(hh.finish());
}
"""


def canon_expr(ret, var):
    """Rust expression producing the canonical String of `var` (result type `ret`)."""
    if "ListNode" in ret:
        return f"__canon_list(&{var})"
    return f'format!("{{:?}}", &{var})'


def ret_hashable(ret):
    """True if `ret` is composed only of Hash-able primitives (integers, bool,
    String, char, unit, and Vec-nestings of those) so it can be folded via
    std::hash::Hash with NO string build. f32/f64/Vec<f64>, tuples, and
    Tree/ListNode types are NOT Hash-able here -> keep the format!/canon path."""
    t = ret.strip()
    if t in ("", "()"):
        return True  # unit impls Hash; folding it avoids a string alloc
    while t.startswith("Vec<") and t.endswith(">"):
        t = t[4:-1].strip()
    return t in INT_TYPES or t in ("bool", "String", "char")


def fold_snippet(ret):
    """Rust statements (12-space indented) folding measured-loop result `r` into
    `acc`: a direct Hash fold when possible, else the canonical-string byte hash."""
    if ret_hashable(ret):
        return "            __hfold(std::hint::black_box(&r), &mut acc);"
    return ("            let s = " + canon_expr(ret, "r") + ";\n"
            "            __hash(std::hint::black_box(&s), &mut acc);")


# ---------------------------------------------------------------------------
# main() prologue shared by plain / tree-list paths: load doc, pick case, expose
# `ev` = the input object's (key, JVal) entries in signature order.
# ---------------------------------------------------------------------------

MAIN_PROLOGUE = """    let argv: Vec<String> = std::env::args().collect();
    let budget: f64 = argv.get(1).and_then(|x| x.parse().ok()).unwrap_or(1.0);
    let idx: usize = argv.get(2).and_then(|x| x.parse().ok()).unwrap_or(0);
    let doc = __load();
    let cases = doc.field("expected").as_arr();
    let kase = &cases[idx];
    let name = kase.field("name").as_str().to_string();
    let input = kase.field("input");
    let ev = input.as_obj();
"""

# ---------------------------------------------------------------------------
# Plain-data path
# ---------------------------------------------------------------------------

PLAIN_TEMPLATE = """
// ---- generated harness driver (do not edit; produced by harness_rust.py) ----
__JSON_MOD____HASH_FN____HFOLD_FN__
fn main() {
__PROLOGUE__
    let do_call = || {
__ARG_LETS__
        Solution::__RNAME__(__CALL_ARGS__)
    };
    let first = do_call();
    let beacon = format!("{:?}", &first);
    if std::env::var("HARNESS_EMIT_RESULT").is_ok() {
        println!("{:?}", &first);
    }
    let warm = budget * 0.3;
    let mut warm_iters: u64 = 0;
    let t0 = std::time::Instant::now();
    while t0.elapsed().as_secs_f64() < warm {
        std::hint::black_box(do_call());
        warm_iters += 1;
    }
    // Estimate per-iteration cost from warmup and read the wall clock only every
    // ~2ms (batch inner iterations) to amortize the Instant::now() syscall.
    let per_iter = t0.elapsed().as_secs_f64() / (warm_iters.max(1) as f64);
    let batch: u64 = ((0.002 / per_iter) as i64).clamp(1, 4096) as u64;
    let mut acc: u64 = 0;
    let mut iters: u64 = 0;
    let tm = std::time::Instant::now();
    while tm.elapsed().as_secs_f64() < budget - warm {
        for _ in 0..batch {
            let r = do_call();
__FOLD_R__
        }
        iters += batch;
    }
    let meas = tm.elapsed().as_secs_f64();
    let beacon_t: String = beacon.chars().take(80).collect();
    eprintln!("CASE={} ITERS={} ACC={} MEAS_S={:.6} BEACON={}", name, iters, acc, meas, beacon_t);
}
"""

# ---------------------------------------------------------------------------
# Tree / list path (structured args and/or list result)
# ---------------------------------------------------------------------------

STRUCTURED_TEMPLATE = """
// ---- generated harness driver (tree/list; produced by harness_rust.py) ----
__DEFS____JSON_MOD____BUILDERS____HASH_FN____HFOLD_FN__
fn main() {
__PROLOGUE__
    let do_call = || {
__ARG_LETS__
        Solution::__RNAME__(__CALL_ARGS__)
    };
    let first = do_call();
    let beacon = __CANON_FIRST__;
    if std::env::var("HARNESS_EMIT_RESULT").is_ok() {
        println!("{}", &beacon);
    }
    let warm = budget * 0.3;
    let mut warm_iters: u64 = 0;
    let t0 = std::time::Instant::now();
    while t0.elapsed().as_secs_f64() < warm {
        std::hint::black_box(do_call());
        warm_iters += 1;
    }
    // Estimate per-iteration cost from warmup and read the wall clock only every
    // ~2ms (batch inner iterations) to amortize the Instant::now() syscall.
    let per_iter = t0.elapsed().as_secs_f64() / (warm_iters.max(1) as f64);
    let batch: u64 = ((0.002 / per_iter) as i64).clamp(1, 4096) as u64;
    let mut acc: u64 = 0;
    let mut iters: u64 = 0;
    let tm = std::time::Instant::now();
    while tm.elapsed().as_secs_f64() < budget - warm {
        for _ in 0..batch {
            let r = do_call();
__FOLD_R__
        }
        iters += batch;
    }
    let meas = tm.elapsed().as_secs_f64();
    let beacon_t: String = beacon.chars().take(80).collect();
    eprintln!("CASE={} ITERS={} ACC={} MEAS_S={:.6} BEACON={}", name, iters, acc, meas, beacon_t);
}
"""

# ---------------------------------------------------------------------------
# Design-class path (input {ops, args}) -- ops replayed via a RUNTIME loop with a
# name dispatch, so compile time is independent of the op-sequence length.
# ---------------------------------------------------------------------------

DESIGN_TEMPLATE = """
// ---- generated harness driver (design; produced by harness_rust.py) ----
__JSON_MOD____HASH_FN____HFOLD_FN__
#[allow(unused_variables, unused_mut)]
fn __replay(input: &JVal, acc: &mut u64) {
    let args = input.field("args").as_arr();
    let ops = input.field("ops").as_arr();
    let mut __inst = __CTOR__;
    for __i in 1..ops.len() {
        let op = ops[__i].as_str();
        let aa = &args[__i];
        let _ = &aa;
__REPLAY_DISPATCH__
    }
    std::hint::black_box(&__inst);
}

#[allow(unused_variables, unused_mut)]
fn __dump(input: &JVal) -> String {
    let args = input.field("args").as_arr();
    let ops = input.field("ops").as_arr();
    let mut __inst = __CTOR__;
    let mut out = String::from("[null");
    for __i in 1..ops.len() {
        let op = ops[__i].as_str();
        let aa = &args[__i];
        let _ = &aa;
__DUMP_DISPATCH__
    }
    out.push(']');
    out
}

fn main() {
    let argv: Vec<String> = std::env::args().collect();
    let budget: f64 = argv.get(1).and_then(|x| x.parse().ok()).unwrap_or(1.0);
    let idx: usize = argv.get(2).and_then(|x| x.parse().ok()).unwrap_or(0);
    let doc = __load();
    let cases = doc.field("expected").as_arr();
    let kase = &cases[idx];
    let name = kase.field("name").as_str().to_string();
    let input = kase.field("input");
    if std::env::var("HARNESS_EMIT_RESULT").is_ok() {
        println!("{}", __dump(input));
    }
    let warm = budget * 0.3;
    let mut warm_iters: u64 = 0;
    let t0 = std::time::Instant::now();
    while t0.elapsed().as_secs_f64() < warm {
        let mut __w: u64 = 0;
        __replay(input, &mut __w);
        std::hint::black_box(__w);
        warm_iters += 1;
    }
    // Estimate per-replay cost from warmup and read the wall clock only every
    // ~2ms (batch replays) to amortize the Instant::now() syscall.
    let per_iter = t0.elapsed().as_secs_f64() / (warm_iters.max(1) as f64);
    let batch: u64 = ((0.002 / per_iter) as i64).clamp(1, 4096) as u64;
    let mut acc: u64 = 0;
    let mut iters: u64 = 0;
    let tm = std::time::Instant::now();
    while tm.elapsed().as_secs_f64() < budget - warm {
        for _ in 0..batch {
            __replay(input, &mut acc);
        }
        iters += batch;
    }
    let meas = tm.elapsed().as_secs_f64();
    eprintln!("CASE={} ITERS={} ACC={} MEAS_S={:.6} BEACON=design", name, iters, acc, meas);
}
"""


def solution_header(sol):
    return "" if re.search(r"struct\s+Solution\b", sol) else "pub struct Solution;\n\n"


def build_structured(sol, name, sig, values):
    """Tree/list entry method: build args from level-order/array input (parsed at
    runtime), call, and canonicalize (list results -> JSON int array)."""
    rname, params, ret = sig
    if len(values) != len(params):
        raise RuntimeError(f"arity mismatch: {len(params)} params vs {len(values)} inputs")

    need_tree = False
    need_list = False
    arg_lets = []
    call_args = []
    for k, (pname, ptype) in enumerate(params):
        jref = f"&ev[{k}].1"
        if "TreeNode" in ptype:
            need_tree = True
            arg_lets.append(
                "        let a" + str(k) + " = { let __v: Vec<Option<i32>> = ("
                + jref + ").as_arr().iter().map(|__e| if __e.is_null() { None } "
                "else { Some(__e.as_i64() as i32) }).collect(); __build_tree(&__v) };")
        elif "ListNode" in ptype:
            need_list = True
            arg_lets.append(
                "        let a" + str(k) + " = { let __v: Vec<i32> = ("
                + jref + ").as_arr().iter().map(|__e| __e.as_i64() as i32).collect(); "
                "__build_list(&__v) };")
        else:
            arg_lets.append(f"        let a{k} = {marshal_expr(ptype, jref)};")
        call_args.append(f"std::hint::black_box(a{k})")
    if "ListNode" in ret:
        need_list = True

    defs = ""
    if need_tree and not re.search(r"struct\s+TreeNode\b", sol):
        defs += TREE_DEF
    if need_list and not re.search(r"struct\s+ListNode\b", sol):
        defs += LIST_DEF

    builder_block = ""
    if need_tree:
        builder_block += BUILD_TREE_FN
    if need_list:
        builder_block += BUILD_LIST_FN + CANON_LIST_FN

    driver = (STRUCTURED_TEMPLATE
              .replace("__DEFS__", defs)
              .replace("__JSON_MOD__", JSON_MOD)
              .replace("__BUILDERS__", builder_block)
              .replace("__HASH_FN__", HASH_FN)
              .replace("__HFOLD_FN__", HFOLD_FN)
              .replace("__PROLOGUE__", MAIN_PROLOGUE)
              .replace("__ARG_LETS__", "\n".join(arg_lets))
              .replace("__RNAME__", rname)
              .replace("__CALL_ARGS__", ", ".join(call_args))
              .replace("__CANON_FIRST__", canon_expr(ret, "first"))
              .replace("__FOLD_R__", fold_snippet(ret)))
    return solution_header(sol) + sol + "\n" + driver, name


def build_design(sol, name, inp, cases):
    """Design class replay: ops[0]=::new(args[0]), then method ops[i](args[i]).
    The op sequence is replayed by a RUNTIME loop over the parsed JSON (a fixed
    per-method dispatch), so codegen size is independent of the sequence length."""
    ops = inp["ops"]
    args = inp["args"]
    if not ops:
        raise RuntimeError("empty ops")

    struct = str(ops[0])
    if not re.search(r"\b(struct|impl)\s+" + re.escape(struct) + r"\b", sol):
        struct = "Solution"

    ctor_args = args[0] if args else []
    csig = find_method(sol, norm("new"), len(ctor_args))
    if csig is None:
        raise RuntimeError("no ::new constructor found")
    _cn, cparams, _cr = csig
    if len(cparams) != len(ctor_args):
        raise RuntimeError(f"ctor arity mismatch: {len(cparams)} vs {len(ctor_args)}")
    ctor_margs = ", ".join(
        marshal_expr(pt, f"&args[0].as_arr()[{j}]") for j, (pn, pt) in enumerate(cparams))
    ctor = f"{struct}::new({ctor_margs})"

    # Distinct method op-names across ALL cases (order-preserving), each dispatched
    # by its resolved Rust method + statically-known param types.
    seen, opnames = set(), []
    for c in cases:
        cin = c["input"]
        for o in cin["ops"][1:]:
            o = str(o)
            if o not in seen:
                seen.add(o)
                opnames.append(o)

    replay_branches = []
    dump_branches = []
    for n_i, opn in enumerate(opnames):
        # Determine this op's argc from any case that uses it.
        argc = 0
        found = False
        for c in cases:
            cin = c["input"]
            for k, o in enumerate(cin["ops"]):
                if str(o) == opn:
                    argc = len(cin["args"][k])
                    found = True
                    break
            if found:
                break
        msig = find_method(sol, norm(opn), argc)
        if msig is None:
            raise RuntimeError(f"no method matching op {opn!r}")
        mn, mparams, mret = msig
        margs = ", ".join(
            marshal_expr(pt, f"&aa.as_arr()[{j}]") for j, (pn, pt) in enumerate(mparams))
        call = f"__inst.{mn}({margs})"
        kw = "if" if n_i == 0 else "else if"
        if ret_hashable(mret):
            fold = "            __hfold(&__r, acc);"
        else:
            fold = '            __hash(&format!("{:?}", &__r), acc);'
        replay_branches.append(
            f'        {kw} op == "{opn}" {{\n'
            f'            let __r = std::hint::black_box({call});\n'
            f'{fold}\n'
            f'        }}')
        if mret in ("", "()"):
            dump_branches.append(
                f'        {kw} op == "{opn}" {{\n'
                f'            {call};\n'
                f'            out.push_str(",null");\n'
                f'        }}')
        else:
            dump_branches.append(
                f'        {kw} op == "{opn}" {{\n'
                f'            let __t = {call};\n'
                f"            out.push(',');\n"
                f'            out.push_str(&format!("{{:?}}", &__t));\n'
                f'        }}')

    driver = (DESIGN_TEMPLATE
              .replace("__JSON_MOD__", JSON_MOD)
              .replace("__HASH_FN__", HASH_FN)
              .replace("__HFOLD_FN__", HFOLD_FN)
              .replace("__CTOR__", ctor)
              .replace("__REPLAY_DISPATCH__", "\n".join(replay_branches))
              .replace("__DUMP_DISPATCH__", "\n".join(dump_branches)))
    # Design solutions already declare their structs; no Solution header needed.
    return sol + "\n" + driver, name


# ===========================================================================
# Full-suite correctness validation. ONE compiled binary loops EVERY reference
# case, runs it once, and compares to the expected output by marshalling the
# expected JSON into the result type and comparing Rust values with `==` (exact,
# no Debug-format matching). Design/trace cases skip null-expected positions
# (void ops LeetCode discards). Exit: 0 Accepted, 1 Wrong Answer, 3 Runtime
# Error (a solution panic); the driver prints one VALIDATE line to stderr.
# ===========================================================================

VALIDATE_CALL_TEMPLATE = """
// ---- generated validate driver (call; produced by harness_rust.py) ----
__DEFS____JSON_MOD____BUILDERS__
#[allow(unused)]
fn main() {
    std::panic::set_hook(Box::new(|_| {}));
    let slug = "__SLUG__";
    let doc = __load();
    let cases = doc.field("expected").as_arr();
    for kase in cases {
        let name = kase.field("name").as_str().to_string();
        let __res = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| -> i32 {
            let input = kase.field("input");
            let ev = input.as_obj();
            let expected = kase.field("output");
            let _ = (&ev, &expected);
__ARG_LETS__
            let __actual = Solution::__RNAME__(__CALL_ARGS__);
__CMP__
            0i32
        }));
        match __res {
            Ok(0) => {}
            Ok(code) => std::process::exit(code),
            Err(_) => { eprintln!("VALIDATE slug={} RE case={} panic", slug, name); std::process::exit(3); }
        }
    }
    eprintln!("VALIDATE slug={} PASS ncases={}", slug, cases.len());
}
"""

VALIDATE_DESIGN_TEMPLATE = """
// ---- generated validate driver (design; produced by harness_rust.py) ----
__JSON_MOD__
#[allow(unused)]
fn main() {
    std::panic::set_hook(Box::new(|_| {}));
    let slug = "__SLUG__";
    let randomized = __RANDOMIZED__;
    let doc = __load();
    let cases = doc.field("expected").as_arr();
    for kase in cases {
        let name = kase.field("name").as_str().to_string();
        let __res = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| -> i32 {
            let input = kase.field("input");
            let args = input.field("args").as_arr();
            let ops = input.field("ops").as_arr();
            let expected = kase.field("output").as_arr();
            let __nums: Vec<i64> = if randomized {
                args[0].as_arr()[0].as_arr().iter().map(|__e| __e.as_i64()).collect()
            } else { Vec::new() };
            let mut __inst = __CTOR__;
            for __i in 1..ops.len() {
                let op = ops[__i].as_str();
                let aa = &args[__i];
                let __exp = &expected[__i];
                let _ = (&aa, &__exp, &__nums);
__VALIDATE_DISPATCH__
            }
            std::hint::black_box(&__inst);
            0i32
        }));
        match __res {
            Ok(0) => {}
            Ok(code) => std::process::exit(code),
            Err(_) => { eprintln!("VALIDATE slug={} RE case={} panic", slug, name); std::process::exit(3); }
        }
    }
    eprintln!("VALIDATE slug={} PASS ncases={}", slug, cases.len());
}
"""


def build_validate_call(sol, slug, sig):
    """Plain OR tree/list entry method -> validate driver (marshal expected into
    the return type, compare with ==; ListNode results compared via __canon_list)."""
    rname, params, ret = sig
    need_tree = need_list = False
    arg_lets, call_args = [], []
    for k, (pname, ptype) in enumerate(params):
        jref = f"&ev[{k}].1"
        if "TreeNode" in ptype:
            need_tree = True
            arg_lets.append(
                "            let a%d = { let __v: Vec<Option<i32>> = (%s).as_arr().iter()"
                ".map(|__e| if __e.is_null() { None } else { Some(__e.as_i64() as i32) })"
                ".collect(); __build_tree(&__v) };" % (k, jref))
        elif "ListNode" in ptype:
            need_list = True
            arg_lets.append(
                "            let a%d = { let __v: Vec<i32> = (%s).as_arr().iter()"
                ".map(|__e| __e.as_i64() as i32).collect(); __build_list(&__v) };" % (k, jref))
        else:
            arg_lets.append(f"            let a{k} = {marshal_expr(ptype, jref)};")
        call_args.append(f"a{k}")

    if slug in _UNORDERED and ret.startswith("Vec<"):
        exp_marsh = marshal_expr(ret, "expected")   # Vec<..> is marshalable, Clone + Ord
        cmp = (
            f"            let __exp: {ret} = {exp_marsh};\n"
            "            let mut __a = __actual.clone(); __a.sort();\n"
            "            let mut __e = __exp.clone(); __e.sort();\n"
            "            if __a != __e {\n"
            '                eprintln!("VALIDATE slug={} FAIL case={} (unordered) expected={:?} actual={:?}", slug, name, __exp, __actual);\n'
            "                return 1i32;\n"
            "            }")
    elif "ListNode" in ret:
        need_list = True
        cmp = (
            "            let __a = __canon_list(&__actual);\n"
            "            let __e_ints: Vec<i32> = expected.as_arr().iter().map(|__e| __e.as_i64() as i32).collect();\n"
            "            let __e = __canon_list(&__build_list(&__e_ints));\n"
            "            if __a != __e {\n"
            '                eprintln!("VALIDATE slug={} FAIL case={} expected={} actual={}", slug, name, __e, __a);\n'
            "                return 1i32;\n"
            "            }")
    elif "TreeNode" in ret:
        raise RuntimeError("validate: TreeNode result unsupported")
    else:
        exp_marsh = marshal_expr(ret, "expected")   # ValueError -> unsupported
        cmp = (
            f"            let __exp: {ret} = {exp_marsh};\n"
            "            if __actual != __exp {\n"
            '                eprintln!("VALIDATE slug={} FAIL case={} expected={:?} actual={:?}", slug, name, __exp, __actual);\n'
            "                return 1i32;\n"
            "            }")

    defs = ""
    if need_tree and not re.search(r"struct\s+TreeNode\b", sol): defs += TREE_DEF
    if need_list and not re.search(r"struct\s+ListNode\b", sol): defs += LIST_DEF
    builders = ""
    if need_tree: builders += BUILD_TREE_FN
    if need_list: builders += BUILD_LIST_FN + CANON_LIST_FN

    driver = (VALIDATE_CALL_TEMPLATE
              .replace("__DEFS__", defs)
              .replace("__JSON_MOD__", JSON_MOD)
              .replace("__BUILDERS__", builders)
              .replace("__SLUG__", slug)
              .replace("__ARG_LETS__", "\n".join(arg_lets))
              .replace("__RNAME__", rname)
              .replace("__CALL_ARGS__", ", ".join(call_args))
              .replace("__CMP__", cmp))
    return solution_header(sol) + sol + "\n" + driver


def build_validate_design(sol, slug, inp, cases, randomized):
    ops = inp["ops"]; args = inp["args"]
    if not ops:
        raise RuntimeError("empty ops")
    struct = str(ops[0])
    if not re.search(r"\b(struct|impl)\s+" + re.escape(struct) + r"\b", sol):
        struct = "Solution"
    ctor_args = args[0] if args else []
    csig = find_method(sol, norm("new"), len(ctor_args))
    if csig is None:
        raise RuntimeError("no ::new constructor found")
    _cn, cparams, _cr = csig
    if len(cparams) != len(ctor_args):
        raise RuntimeError(f"ctor arity mismatch: {len(cparams)} vs {len(ctor_args)}")
    ctor_margs = ", ".join(
        marshal_expr(pt, f"&args[0].as_arr()[{j}]") for j, (pn, pt) in enumerate(cparams))
    ctor = f"{struct}::new({ctor_margs})"

    seen, opnames = set(), []
    for c in cases:
        for o in c["input"]["ops"][1:]:
            o = str(o)
            if o not in seen: seen.add(o); opnames.append(o)

    branches = []
    for n_i, opn in enumerate(opnames):
        argc, found = 0, False
        for c in cases:
            cin = c["input"]
            for k, o in enumerate(cin["ops"]):
                if str(o) == opn:
                    argc = len(cin["args"][k]); found = True; break
            if found: break
        msig = find_method(sol, norm(opn), argc)
        if msig is None:
            raise RuntimeError(f"no method matching op {opn!r}")
        mn, mparams, mret = msig
        margs = ", ".join(
            marshal_expr(pt, f"&aa.as_arr()[{j}]") for j, (pn, pt) in enumerate(mparams))
        call = f"__inst.{mn}({margs})"
        kw = "if" if n_i == 0 else "else if"
        if mret in ("", "()"):                       # void op: run, do not compare
            branches.append(f'        {kw} op == "{opn}" {{\n            {call};\n        }}')
        elif randomized and opn == "pick":           # pick returns an index -> nums[index]
            branches.append(
                f'        {kw} op == "{opn}" {{\n'
                f'            let __r = {call};\n'
                f'            if !__exp.is_null() {{\n'
                f'                let __p = __nums[__r as usize];\n'
                f'                if __p != (__exp).as_i64() {{\n'
                f'                    eprintln!("VALIDATE slug={{}} FAIL case={{}} pos={{}} expected={{}} actual={{}}", slug, name, __i, (__exp).as_i64(), __p);\n'
                f'                    return 1i32;\n'
                f'                }}\n'
                f'            }}\n'
                f'        }}')
        else:
            em = marshal_expr(mret, "__exp")         # ValueError -> unsupported
            branches.append(
                f'        {kw} op == "{opn}" {{\n'
                f'            let __r = {call};\n'
                f'            if !__exp.is_null() {{\n'
                f'                let __e: {mret} = {em};\n'
                f'                if __r != __e {{\n'
                f'                    eprintln!("VALIDATE slug={{}} FAIL case={{}} pos={{}} expected={{:?}} actual={{:?}}", slug, name, __i, __e, __r);\n'
                f'                    return 1i32;\n'
                f'                }}\n'
                f'            }}\n'
                f'        }}')
    dispatch = "\n".join(branches)
    driver = (VALIDATE_DESIGN_TEMPLATE
              .replace("__JSON_MOD__", JSON_MOD)
              .replace("__SLUG__", slug)
              .replace("__RANDOMIZED__", "true" if randomized else "false")
              .replace("__CTOR__", ctor)
              .replace("__VALIDATE_DISPATCH__", dispatch))
    return sol + "\n" + driver


def build_validate_combined(cell, slug, ref):
    """Build a single validate driver covering every case, or raise
    ValueError/RuntimeError when the problem uses an unsupported shape/type."""
    with open(os.path.join(ref, "outputs", slug + ".json")) as f:
        cases = json.load(f)["expected"]
    inp = cases[0]["input"]
    with open(os.path.join(cell, "solution.rs")) as f:
        sol = f.read()
    randomized = (slug == "random-pick-index")
    if isinstance(inp, dict) and "ops" in inp and "args" in inp:
        return build_validate_design(sol, slug, inp, cases, randomized)
    with open(os.path.join(ref, "workloads", slug + ".json")) as f:
        wl = json.load(f)
    ep = str(wl.get("entry_point", ""))
    method_tok = ep.split(".")[-1].replace("()", "").strip()
    sig = find_signature(sol, norm(method_tok))
    if sig is None:
        raise RuntimeError(f"no method matching entry_point {ep!r}")
    return build_validate_call(sol, slug, sig)


def run_validate(cell, slug, ref):
    """Compile ONE validate driver and run it over every case. Returns the
    binary's exit code (0 Accepted, 1 Wrong Answer, 3 Runtime Error) or 2 on a
    setup/compile/unsupported error so the caller can fall back."""
    try:
        combined = build_validate_combined(cell, slug, ref)
    except (ValueError, RuntimeError) as e:
        sys.stderr.write(f"VALIDATE slug={slug} ERROR unsupported: {e}\n")
        return 2
    tmp = tempfile.mkdtemp(prefix="hzv_rust_")
    src_path = os.path.join(tmp, "combined.rs")
    bin_path = os.path.join(tmp, "driver")
    with open(src_path, "w") as f:
        f.write(combined)
    try:
        cp = subprocess.run([RUSTC, "-O", src_path, "-o", bin_path],
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if cp.returncode != 0:
            last = cp.stderr.strip().splitlines()[-1] if cp.stderr else ""
            sys.stderr.write(f"VALIDATE slug={slug} ERROR compile: {last}\n")
            return 2
        run = subprocess.run([bin_path], text=True, cwd=cell, timeout=300)
        return run.returncode
    finally:
        for p in (src_path, bin_path):
            try: os.remove(p)
            except OSError: pass
        try: os.rmdir(tmp)
        except OSError: pass


def build_combined(cell, slug, ref, idx):
    """Returns (combined_source, case_name) or raises RuntimeError/ValueError for
    unsupported problems."""
    with open(os.path.join(ref, "outputs", slug + ".json")) as f:
        out = json.load(f)
    cases = out["expected"]
    case = cases[idx]
    name = str(case["name"])
    inp = case["input"]

    with open(os.path.join(cell, "solution.rs")) as f:
        sol = f.read()

    if isinstance(inp, dict) and "ops" in inp and "args" in inp:
        return build_design(sol, name, inp, cases)

    with open(os.path.join(ref, "workloads", slug + ".json")) as f:
        wl = json.load(f)
    ep = str(wl.get("entry_point", ""))
    method_tok = ep.split(".")[-1].replace("()", "").strip()
    sig = find_signature(sol, norm(method_tok))
    if sig is None:
        raise RuntimeError(f"no method matching entry_point {ep!r}")
    _rname, params, ret = sig

    joined = " ".join(t for _, t in params) + " " + ret
    values = list(inp.values())
    if "TreeNode" in joined or "ListNode" in joined:
        return build_structured(sol, name, sig, values)

    # plain-data path
    if len(values) != len(params):
        raise RuntimeError(f"arity mismatch: {len(params)} params vs {len(values)} inputs")
    arg_lets = []
    call_args = []
    for k, (pname, ptype) in enumerate(params):
        expr = marshal_expr(ptype, f"&ev[{k}].1")  # raises ValueError -> unsupported
        arg_lets.append(f"        let a{k} = {expr};")
        call_args.append(f"std::hint::black_box(a{k})")

    driver = (PLAIN_TEMPLATE
              .replace("__JSON_MOD__", JSON_MOD)
              .replace("__HASH_FN__", HASH_FN)
              .replace("__HFOLD_FN__", HFOLD_FN)
              .replace("__PROLOGUE__", MAIN_PROLOGUE)
              .replace("__ARG_LETS__", "\n".join(arg_lets))
              .replace("__RNAME__", _rname)
              .replace("__CALL_ARGS__", ", ".join(call_args))
              .replace("__FOLD_R__", fold_snippet(ret)))
    return solution_header(sol) + sol + "\n" + driver, name


def main():
    if len(sys.argv) >= 2 and sys.argv[1] == "validate":
        cell = os.getcwd()
        slug = os.path.basename(cell)
        ref = os.path.join(cell, "..", "..", "..", "reference", "leetcode")
        return run_validate(cell, slug, ref)
    if len(sys.argv) < 3:
        sys.stderr.write("usage: harness_rust.py <budget_seconds> <case_index>\n")
        return 2
    budget = sys.argv[1]
    idx = int(sys.argv[2])
    cell = os.getcwd()
    slug = os.path.basename(cell)
    ref = os.path.join(cell, "..", "..", "..", "reference", "leetcode")

    try:
        combined, _name = build_combined(cell, slug, ref, idx)
    except ValueError as e:  # unsupported type in signature
        sys.stderr.write(f"UNSUPPORTED slug={slug}: {e}\n")
        return 4
    except RuntimeError as e:
        msg = str(e)
        if msg.startswith("DEFER="):
            sys.stderr.write(f"{msg} slug={slug}\n")
            return 3
        sys.stderr.write(f"SKIP slug={slug}: {msg}\n")
        return 4

    tmp = tempfile.mkdtemp(prefix="hz_rust_")
    src_path = os.path.join(tmp, "combined.rs")
    bin_path = os.path.join(tmp, "driver")
    with open(src_path, "w") as f:
        f.write(combined)
    try:
        cp = subprocess.run(
            [RUSTC, "-O", src_path, "-o", bin_path],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True,
        )
        if cp.returncode != 0:
            sys.stderr.write(f"COMPILE_FAIL slug={slug}\n{cp.stderr}\n")
            return 5
        run = subprocess.run([bin_path, str(budget), str(idx)], text=True, cwd=cell)
        return run.returncode
    finally:
        for p in (src_path, bin_path):
            try:
                os.remove(p)
            except OSError:
                pass
        try:
            os.rmdir(tmp)
        except OSError:
            pass


if __name__ == "__main__":
    sys.exit(main())
