"""Generate CLBG-shape Makefile + test_suite.<ext> for every LC-energy cell.

Each cell already ships with:
  * problem.json  — has `code_snippets` per language with the LC-official
                    signature (`class Solution: def minSteps(self, n: int)...`)
  * solution.<ext> — the model's submitted code (skeleton pre-submission)

This codegen:
  1. Parses the code_snippets entry for that (language, problem) to
     extract method name, return type, and each parameter's (name, type).
  2. Emits `test_suite.<ext>` — a runnable that constructs default-valued
     arguments of the right type, calls `Solution().method(...)` once,
     and exits. No correctness comparison — perf-benchmarking only, per
     the user's spec ("assume correctness was already validated").
  3. Emits a CLBG-shape `Makefile` — includes ../../../perfarena.mk so
     compile / measure / mem / run all flow through the same
     infrastructure CLBG cells already use.

Supported types (per language, in each language's native tokens):
  * scalars:  int, string, bool, double
  * arrays:   int[], string[], int[][]
  * lists:    List<Integer>, List<String>, List<List<Integer>>

Anything else (TreeNode, ListNode, char, Node, custom classes) is
skipped and reported. Coverage varies by language and by problem — some
have >90% supported signatures, some (linked-list / tree problems)
skip more.

Idempotent: existing test_suite files are overwritten only with
--overwrite. Existing Makefiles are always overwritten so the
CLBG-shape template rolls out consistently.

Usage:
    .venv-runner/bin/python scripts/generate_lc_cells.py
    .venv-runner/bin/python scripts/generate_lc_cells.py --dry-run
    .venv-runner/bin/python scripts/generate_lc_cells.py --languages java,cpp
    .venv-runner/bin/python scripts/generate_lc_cells.py --overwrite
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent.parent


# ---------- language descriptor ------------------------------------------

@dataclass
class Lang:
    key: str                     # LC snippet key
    folder: str                  # tree folder name
    ext: str                     # solution extension
    suite_filename: str          # test suite filename in the cell
    output_artifact: str         # what perfarena.mk's OUTPUT variable points at
    run_cmd: str                 # how make runs the compiled binary
    compile_cmd: str             # how make compiles solution + suite together
    # If the language has no separate compile step (interpreted), leave
    # `compile_cmd` empty and OUTPUT = SOURCE.

LANGS: dict[str, Lang] = {
    # LC-energy folder name → Lang. COMPILE_CMDs deliberately look
    # unusual because LC solutions ship without a package declaration
    # (Go), without `struct Solution` (Rust), etc. We normalise on the
    # fly by concatenating with a small header rather than editing
    # user-submitted source.
    "Python":     Lang("python3",    "Python",     "py",     "test_suite.py",    "test_suite.py",
                       "python3 test_suite.py", ""),
    "Java":       Lang("java",       "Java",       "java",   "TestSuite.java",   "TestSuite.class",
                       "java -cp . TestSuite",
                       "$(JAVAC) solution.java TestSuite.java"),
    "C++":        Lang("cpp",        "C++",        "cpp",    "test_suite.cpp",   "test_suite",
                       "./test_suite",
                       "$(CXX) -O2 -std=c++17 test_suite.cpp -o test_suite"),
    "CSharp":     Lang("csharp",     "CSharp",     "cs",     "TestSuite.cs",     "test_suite",
                       "./test_suite",
                       "$(CSC) -out:test_suite solution.cs TestSuite.cs"),
    # Go: solution.go has NO `package main`. Prepend one at compile
    # time, then compile with test_suite.go which already declares it.
    # NB: the temp file MUST NOT start with `_` — Go's build system
    # excludes files with leading underscore/dot from compilation, so
    # a `_sol_combined.go` name silently skips the whole solution.
    "Go":         Lang("golang",     "Go",         "go",     "test_suite.go",    "test_suite",
                       "./test_suite",
                       "{ printf 'package main\\n\\n' ; cat solution.go ; } > sol_combined.go && "
                       "$(GO) build -o test_suite sol_combined.go test_suite.go"),
    "JavaScript": Lang("javascript", "JavaScript", "js",     "test_suite.js",    "test_suite.js",
                       "node test_suite.js", ""),
    "PHP":        Lang("php",        "PHP",        "php",    "test_suite.php",   "test_suite.php",
                       "php test_suite.php", ""),
    "Ruby":       Lang("ruby",       "Ruby",       "rb",     "test_suite.rb",    "test_suite.rb",
                       "ruby test_suite.rb", ""),
    # Rust: solution.rs has `impl Solution` but no `struct Solution;`.
    # Concatenate: header + solution.rs (has impl) + test_suite.rs body.
    "Rust":       Lang("rust",       "Rust",       "rs",     "test_suite.rs",    "test_suite",
                       "./test_suite",
                       "{ printf 'pub struct Solution;\\n\\n' ; cat solution.rs ; cat test_suite.rs ; } > _combined.rs && "
                       "$(RUSTC) -O _combined.rs -o test_suite"),
    # TS: --outFile is deprecated in modern tsc. Concatenate first, then
    # compile the single file → .js.
    "TypeScript": Lang("typescript", "TypeScript", "ts",     "test_suite.ts",    "combined.js",
                       "node combined.js",
                       "cat solution.ts test_suite.ts > combined.ts && "
                       "tsc --target es2020 --module commonjs --strict false --skipLibCheck combined.ts"),
}


# ---------- signature extraction (per LC snippet language) ---------------

@dataclass
class Sig:
    method: str
    return_type: str
    params: list[tuple[str, str]]   # [(name, type)]


class Skip(Exception):
    """Raised when we can't handle a signature. Reason surfaces in the report."""


# --- Python signature parser ---
_PY_SIG = re.compile(
    r"def\s+(?P<method>\w+)\s*\(self\s*(?:,\s*(?P<params>[^)]*))?\)\s*(?:->\s*(?P<ret>[^:]+))?:",
)


def parse_python(snippet: str) -> Sig:
    m = _PY_SIG.search(snippet)
    if not m:
        raise Skip("no `def method(self, ...):` on Solution")
    method = m.group("method")
    ret = (m.group("ret") or "None").strip()
    params_src = (m.group("params") or "").strip()
    params: list[tuple[str, str]] = []
    if params_src:
        for part in _split_top_level(params_src):
            part = part.strip()
            if ":" in part:
                name, ty = part.split(":", 1)
                params.append((name.strip(), ty.strip()))
            else:
                # untyped param
                params.append((part.strip(), "int"))
    return Sig(method=method, return_type=ret, params=params)


# --- Java signature parser ---
_JAVA_SIG = re.compile(
    r"public\s+(?P<ret>[\w<>\[\], ?]+?)\s+(?P<method>\w+)\s*\((?P<params>[^)]*)\)",
)


def parse_java(snippet: str) -> Sig:
    m = _JAVA_SIG.search(snippet)
    if not m:
        raise Skip("no public method signature")
    method = m.group("method")
    ret = m.group("ret").strip()
    params_src = m.group("params").strip()
    params: list[tuple[str, str]] = []
    if params_src:
        for part in _split_top_level(params_src):
            part = part.strip()
            toks = part.rsplit(" ", 1)
            if len(toks) != 2:
                raise Skip(f"can't parse Java param: {part!r}")
            ty, name = toks[0].strip(), toks[1].strip()
            params.append((name, ty))
    return Sig(method=method, return_type=ret, params=params)


# --- C++ signature parser ---
_CPP_SIG = re.compile(
    r"(?P<ret>[\w<>\[\], :]+?)\s+(?P<method>\w+)\s*\((?P<params>[^)]*)\)\s*\{",
)


def parse_cpp(snippet: str) -> Sig:
    # First strip `public:` etc. so the regex isn't distracted.
    body = re.sub(r"public\s*:|private\s*:|protected\s*:", "", snippet)
    m = _CPP_SIG.search(body)
    if not m:
        raise Skip("no method signature")
    method = m.group("method").strip()
    if method in ("Solution", "if", "for", "while"):
        raise Skip(f"parsed constructor/keyword `{method}` — bad regex hit")
    ret = m.group("ret").strip()
    params_src = m.group("params").strip()
    params: list[tuple[str, str]] = []
    if params_src:
        for part in _split_top_level(params_src):
            part = part.strip()
            # Strip `&` reference sigils; use base type.
            part = part.replace("&", " ")
            toks = part.rsplit(" ", 1)
            if len(toks) != 2:
                raise Skip(f"can't parse C++ param: {part!r}")
            ty, name = toks[0].strip(), toks[1].strip()
            params.append((name, ty))
    return Sig(method=method, return_type=ret, params=params)


# --- CSharp signature parser ---
_CS_SIG = re.compile(
    r"public\s+(?P<ret>[\w<>\[\], ?]+?)\s+(?P<method>\w+)\s*\((?P<params>[^)]*)\)",
)


def parse_csharp(snippet: str) -> Sig:
    m = _CS_SIG.search(snippet)
    if not m:
        raise Skip("no public method signature")
    method = m.group("method")
    ret = m.group("ret").strip()
    params_src = m.group("params").strip()
    params: list[tuple[str, str]] = []
    if params_src:
        for part in _split_top_level(params_src):
            part = part.strip()
            toks = part.rsplit(" ", 1)
            if len(toks) != 2:
                raise Skip(f"can't parse CSharp param: {part!r}")
            ty, name = toks[0].strip(), toks[1].strip()
            params.append((name, ty))
    return Sig(method=method, return_type=ret, params=params)


# --- Go signature parser ---
_GO_SIG = re.compile(
    r"func\s+(?P<method>\w+)\s*\((?P<params>[^)]*)\)\s+(?P<ret>[\w<>\[\], ]+)\s*\{",
)


def parse_go(snippet: str) -> Sig:
    m = _GO_SIG.search(snippet)
    if not m:
        raise Skip("no func signature")
    method = m.group("method")
    ret = m.group("ret").strip()
    params_src = m.group("params").strip()
    params: list[tuple[str, str]] = []
    if params_src:
        for part in _split_top_level(params_src):
            part = part.strip()
            toks = part.rsplit(" ", 1)
            if len(toks) != 2:
                raise Skip(f"can't parse Go param: {part!r}")
            # Go declares `name type` (opposite of Java)
            name, ty = toks[0].strip(), toks[1].strip()
            params.append((name, ty))
    return Sig(method=method, return_type=ret, params=params)


# --- Rust signature parser ---
_RUST_SIG = re.compile(
    r"pub\s+fn\s+(?P<method>\w+)\s*\((?P<params>[^)]*)\)\s*(?:->\s*(?P<ret>[\w<>\[\], ]+))?\s*\{",
)


def parse_rust(snippet: str) -> Sig:
    m = _RUST_SIG.search(snippet)
    if not m:
        raise Skip("no pub fn signature")
    method = m.group("method")
    ret = (m.group("ret") or "()").strip()
    params_src = m.group("params").strip()
    params: list[tuple[str, str]] = []
    if params_src:
        for part in _split_top_level(params_src):
            part = part.strip()
            if part in ("&self", "self", "&mut self"):
                continue
            if ":" not in part:
                raise Skip(f"unparseable Rust param: {part!r}")
            name, ty = part.split(":", 1)
            params.append((name.strip(), ty.strip()))
    return Sig(method=method, return_type=ret, params=params)


# --- JavaScript signature parser ---
_JS_SIG = re.compile(r"var\s+(?P<method>\w+)\s*=\s*function\s*\((?P<params>[^)]*)\)")


def parse_javascript(snippet: str) -> Sig:
    m = _JS_SIG.search(snippet)
    if not m:
        raise Skip("no `var method = function(...)` line")
    method = m.group("method")
    params_src = m.group("params").strip()
    # Types come from JSDoc `@param {Type} name` above the function
    type_by_name: dict[str, str] = {}
    for jsm in re.finditer(r"@param\s*\{([^}]+)\}\s*(\w+)", snippet):
        type_by_name[jsm.group(2).strip()] = jsm.group(1).strip()
    ret = "*"
    for jsm in re.finditer(r"@return\s*\{([^}]+)\}", snippet):
        ret = jsm.group(1).strip()
        break
    params = [
        (n.strip(), type_by_name.get(n.strip(), "*"))
        for n in _split_top_level(params_src) if n.strip()
    ]
    return Sig(method=method, return_type=ret, params=params)


# --- PHP signature parser ---
_PHP_SIG = re.compile(r"function\s+(?P<method>\w+)\s*\((?P<params>[^)]*)\)")


def parse_php(snippet: str) -> Sig:
    m = _PHP_SIG.search(snippet)
    if not m:
        raise Skip("no function signature")
    method = m.group("method")
    params_src = m.group("params").strip()
    type_by_name: dict[str, str] = {}
    for phpm in re.finditer(r"@param\s+(\S+)\s+\$(\w+)", snippet):
        type_by_name[phpm.group(2).strip()] = phpm.group(1).strip()
    ret = "*"
    for phpm in re.finditer(r"@return\s+(\S+)", snippet):
        ret = phpm.group(1).strip()
        break
    params: list[tuple[str, str]] = []
    if params_src:
        for part in _split_top_level(params_src):
            part = part.strip().lstrip("$")
            params.append((part, type_by_name.get(part, "*")))
    return Sig(method=method, return_type=ret, params=params)


# --- Ruby signature parser ---
_RB_SIG = re.compile(r"def\s+(?P<method>\w+)\s*(?:\((?P<params>[^)]*)\))?")


def parse_ruby(snippet: str) -> Sig:
    m = _RB_SIG.search(snippet)
    if not m:
        raise Skip("no def signature")
    method = m.group("method")
    params_src = (m.group("params") or "").strip()
    type_by_name: dict[str, str] = {}
    for rbm in re.finditer(r"@param\s*\{([^}]+)\}\s*(\w+)", snippet):
        type_by_name[rbm.group(2).strip()] = rbm.group(1).strip()
    ret = "*"
    for rbm in re.finditer(r"@return\s*\{([^}]+)\}", snippet):
        ret = rbm.group(1).strip()
        break
    params = [
        (n.strip(), type_by_name.get(n.strip(), "*"))
        for n in _split_top_level(params_src) if n.strip()
    ]
    return Sig(method=method, return_type=ret, params=params)


# --- TypeScript signature parser ---
_TS_SIG = re.compile(
    r"function\s+(?P<method>\w+)\s*\((?P<params>[^)]*)\)\s*:\s*(?P<ret>[\w<>\[\], |]+)\s*\{",
)


def parse_typescript(snippet: str) -> Sig:
    m = _TS_SIG.search(snippet)
    if not m:
        raise Skip("no function signature")
    method = m.group("method")
    ret = m.group("ret").strip()
    params_src = m.group("params").strip()
    params: list[tuple[str, str]] = []
    if params_src:
        for part in _split_top_level(params_src):
            part = part.strip()
            if ":" not in part:
                raise Skip(f"untyped TS param: {part!r}")
            name, ty = part.split(":", 1)
            params.append((name.strip(), ty.strip()))
    return Sig(method=method, return_type=ret, params=params)


PARSERS = {
    "Python":     parse_python,
    "Java":       parse_java,
    "C++":        parse_cpp,
    "CSharp":     parse_csharp,
    "Go":         parse_go,
    "Rust":       parse_rust,
    "JavaScript": parse_javascript,
    "PHP":        parse_php,
    "Ruby":       parse_ruby,
    "TypeScript": parse_typescript,
}


# ---------- default-value factories per (language, type) -----------------

# Canonical, coarse type buckets — after coalescing all the different names
# the LC snippets use per language, we fan out to language-specific literals.
class T:
    INT = "int"
    STR = "str"
    BOOL = "bool"
    DBL = "dbl"
    INT_ARR = "int[]"
    STR_ARR = "str[]"
    BOOL_ARR = "bool[]"
    DBL_ARR = "dbl[]"
    INT_2D = "int[][]"
    STR_2D = "str[][]"
    CHR_2D = "char[][]"


def _bucket(lang_folder: str, ty: str) -> str:
    """Coerce a language-native type token into a canonical bucket."""
    t = ty.strip().replace(" ", "")
    tl = t.lower()
    # Two-dimensional array cases
    if any(k in tl for k in (
        "list<list<integer>>", "vector<vector<int>>", "int[][]",
        "list[list[int]]", "number[][]", "vec<vec<i32>>", "[][]int",
    )):
        return T.INT_2D
    if any(k in tl for k in (
        "list<list<string>>", "vector<vector<string>>", "string[][]",
        "list[list[str]]", "string[][]",
    )):
        return T.STR_2D
    if any(k in tl for k in (
        "vector<vector<char>>", "char[][]", "list<list<character>>",
    )):
        return T.CHR_2D
    # One-dimensional arrays — recognise both `int[]` and LC's JSDoc
    # `Integer[]` (used in PHP/Ruby snippets), and their equivalents.
    if any(k in tl for k in (
        "list<integer>", "vector<int>", "int[]", "list[int]", "number[]",
        "vec<i32>", "[]int", "arrayofintegers", "list<int32>",
        "integer[]", "long[]", "vec<i64>", "[]int64",
    )):
        return T.INT_ARR
    if any(k in tl for k in (
        "list<string>", "vector<string>", "string[]", "list[str]",
        "vec<string>", "[]string",
    )):
        return T.STR_ARR
    if any(k in tl for k in ("list<bool", "vector<bool", "bool[]", "vec<bool>", "boolean[]")):
        return T.BOOL_ARR
    if any(k in tl for k in ("list<double", "vector<double", "double[]", "vec<f64", "float[]")):
        return T.DBL_ARR
    # Character 2D grids under various names (LC uses `character[][]` in
    # JSDoc, Go uses [][]byte, C++ uses char[][], etc.). Bucket into
    # CHR_2D so the language-specific literal handles it.
    if any(k in tl for k in (
        "character[][]", "[][]byte", "vector<vector<byte>>",
    )):
        return T.CHR_2D
    # Scalars (add `long long` for C++, LC's `Integer`/`Boolean` for PHP/Ruby)
    if tl in {"int", "integer", "i32", "i64", "long", "longlong",
              "int32", "int64", "uint32", "number", "u32", "u64"}:
        return T.INT
    if tl in {"str", "string", "&str"}:
        return T.STR
    if tl in {"bool", "boolean"}:
        return T.BOOL
    if tl in {"double", "float", "f64", "f32"}:
        return T.DBL
    # Unknown / complex — the caller will Skip.
    raise Skip(f"unsupported type token: {ty!r} on {lang_folder}")


# Language-specific literal for each canonical bucket.
#
# Small values (n = 20, arrays of 5) — the goal is a runnable call, not
# a perf-realistic workload. Bigger workloads can come from later
# test_suite generations that inspect the workload's first case.
_LITS: dict[str, dict[str, str]] = {
    "Python": {
        T.INT: "20", T.STR: '"abcde"', T.BOOL: "True", T.DBL: "1.5",
        T.INT_ARR: "[1,2,3,4,5]", T.STR_ARR: '["a","b","c"]',
        T.BOOL_ARR: "[True,False,True]", T.DBL_ARR: "[1.0,2.0,3.0]",
        T.INT_2D: "[[1,2],[3,4]]", T.STR_2D: '[["a","b"],["c","d"]]',
        T.CHR_2D: '[["a","b"],["c","d"]]',
    },
    "Java": {
        T.INT: "20", T.STR: '"abcde"', T.BOOL: "true", T.DBL: "1.5",
        T.INT_ARR: "new int[]{1,2,3,4,5}",
        T.STR_ARR: 'new String[]{"a","b","c"}',
        T.BOOL_ARR: "new boolean[]{true,false,true}",
        T.DBL_ARR: "new double[]{1.0,2.0,3.0}",
        T.INT_2D: "new int[][]{{1,2},{3,4}}",
        T.STR_2D: 'new String[][]{{"a","b"},{"c","d"}}',
        T.CHR_2D: "new char[][]{{'a','b'},{'c','d'}}",
    },
    "C++": {
        T.INT: "20", T.STR: '"abcde"', T.BOOL: "true", T.DBL: "1.5",
        T.INT_ARR: "std::vector<int>{1,2,3,4,5}",
        T.STR_ARR: 'std::vector<std::string>{"a","b","c"}',
        T.BOOL_ARR: "std::vector<bool>{true,false,true}",
        T.DBL_ARR: "std::vector<double>{1.0,2.0,3.0}",
        T.INT_2D: "std::vector<std::vector<int>>{{1,2},{3,4}}",
        T.STR_2D: 'std::vector<std::vector<std::string>>{{"a","b"},{"c","d"}}',
        T.CHR_2D: "std::vector<std::vector<char>>{{'a','b'},{'c','d'}}",
    },
    "CSharp": {
        T.INT: "20", T.STR: '"abcde"', T.BOOL: "true", T.DBL: "1.5",
        T.INT_ARR: "new int[]{1,2,3,4,5}",
        T.STR_ARR: 'new string[]{"a","b","c"}',
        T.BOOL_ARR: "new bool[]{true,false,true}",
        T.DBL_ARR: "new double[]{1.0,2.0,3.0}",
        T.INT_2D: "new int[][]{new int[]{1,2},new int[]{3,4}}",
        T.STR_2D: 'new string[][]{new string[]{"a","b"},new string[]{"c","d"}}',
        T.CHR_2D: "new char[][]{new char[]{'a','b'},new char[]{'c','d'}}",
    },
    "Go": {
        T.INT: "20", T.STR: '"abcde"', T.BOOL: "true", T.DBL: "1.5",
        T.INT_ARR: "[]int{1,2,3,4,5}",
        T.STR_ARR: '[]string{"a","b","c"}',
        T.BOOL_ARR: "[]bool{true,false,true}",
        T.DBL_ARR: "[]float64{1.0,2.0,3.0}",
        T.INT_2D: "[][]int{{1,2},{3,4}}",
        T.STR_2D: '[][]string{{"a","b"},{"c","d"}}',
        T.CHR_2D: "[][]byte{{'a','b'},{'c','d'}}",
    },
    "Rust": {
        T.INT: "20", T.STR: 'String::from("abcde")', T.BOOL: "true", T.DBL: "1.5",
        T.INT_ARR: "vec![1,2,3,4,5]",
        T.STR_ARR: 'vec![String::from("a"),String::from("b"),String::from("c")]',
        T.BOOL_ARR: "vec![true,false,true]",
        T.DBL_ARR: "vec![1.0,2.0,3.0]",
        T.INT_2D: "vec![vec![1,2],vec![3,4]]",
        T.STR_2D: 'vec![vec![String::from("a")],vec![String::from("c")]]',
        T.CHR_2D: "vec![vec!['a','b'],vec!['c','d']]",
    },
    "JavaScript": {
        T.INT: "20", T.STR: '"abcde"', T.BOOL: "true", T.DBL: "1.5",
        T.INT_ARR: "[1,2,3,4,5]", T.STR_ARR: '["a","b","c"]',
        T.BOOL_ARR: "[true,false,true]", T.DBL_ARR: "[1.0,2.0,3.0]",
        T.INT_2D: "[[1,2],[3,4]]", T.STR_2D: '[["a","b"],["c","d"]]',
        T.CHR_2D: '[["a","b"],["c","d"]]',
    },
    "TypeScript": {
        T.INT: "20", T.STR: '"abcde"', T.BOOL: "true", T.DBL: "1.5",
        T.INT_ARR: "[1,2,3,4,5]", T.STR_ARR: '["a","b","c"]',
        T.BOOL_ARR: "[true,false,true]", T.DBL_ARR: "[1.0,2.0,3.0]",
        T.INT_2D: "[[1,2],[3,4]]", T.STR_2D: '[["a","b"],["c","d"]]',
        T.CHR_2D: '[["a","b"],["c","d"]]',
    },
    "PHP": {
        T.INT: "20", T.STR: '"abcde"', T.BOOL: "true", T.DBL: "1.5",
        T.INT_ARR: "array(1,2,3,4,5)",
        T.STR_ARR: 'array("a","b","c")',
        T.BOOL_ARR: "array(true,false,true)",
        T.DBL_ARR: "array(1.0,2.0,3.0)",
        T.INT_2D: "array(array(1,2),array(3,4))",
        T.STR_2D: 'array(array("a","b"),array("c","d"))',
        T.CHR_2D: 'array(array("a","b"),array("c","d"))',
    },
    "Ruby": {
        T.INT: "20", T.STR: '"abcde"', T.BOOL: "true", T.DBL: "1.5",
        T.INT_ARR: "[1,2,3,4,5]", T.STR_ARR: '["a","b","c"]',
        T.BOOL_ARR: "[true,false,true]", T.DBL_ARR: "[1.0,2.0,3.0]",
        T.INT_2D: "[[1,2],[3,4]]", T.STR_2D: '[["a","b"],["c","d"]]',
        T.CHR_2D: '[["a","b"],["c","d"]]',
    },
}


def default_literal(lang_folder: str, ty: str) -> str:
    bucket = _bucket(lang_folder, ty)
    return _LITS[lang_folder][bucket]


# ---------- utils ---------------------------------------------------------

def _split_top_level(s: str) -> list[str]:
    """Split by top-level commas (respecting brackets)."""
    out, depth, buf = [], 0, []
    for ch in s:
        if ch in "([<{": depth += 1
        elif ch in ")]>}": depth -= 1
        elif ch == "," and depth == 0:
            out.append("".join(buf)); buf = []
            continue
        buf.append(ch)
    if buf:
        out.append("".join(buf))
    return out


# ---------- test_suite emitters --------------------------------------------

def emit_python_suite(sig: Sig, args: list[str]) -> str:
    args_str = ", ".join(f"{n}={v}" for (n, _), v in zip(sig.params, args))
    return (
        "# LC-energy test suite (Python) — hardcoded single case.\n"
        "# Correctness is validated separately by a correctness oracle; this file\n"
        "# exists ONLY so the perf pipeline (make measure / make mem) has a\n"
        "# runnable target that calls Solution.\n"
        "from solution import Solution\n\n"
        "def main():\n"
        "    sol = Solution()\n"
        f"    _ = sol.{sig.method}({args_str})\n\n"
        "if __name__ == '__main__':\n"
        "    main()\n"
    )


def emit_java_suite(sig: Sig, args: list[str]) -> str:
    args_str = ", ".join(args)
    if sig.return_type.strip() == "void":
        # No return to capture. `var` needs a type, so plain call only.
        call_block = f"        sol.{sig.method}({args_str});\n"
    else:
        # Prefer `Object` over `var` so it works with primitive returns
        # too (int/boolean/etc. can't be boxed via `var` in a null check).
        # We just consume the result to prevent JIT elision.
        call_block = (
            f"        Object result = sol.{sig.method}({args_str});\n"
            "        if (result == null) System.out.println(\"null\");\n"
        )
    return (
        "// LC-energy test suite (Java) — hardcoded single case.\n"
        "public class TestSuite {\n"
        "    public static void main(String[] args) {\n"
        "        Solution sol = new Solution();\n"
        f"{call_block}"
        "    }\n"
        "}\n"
    )


def emit_cpp_suite(sig: Sig, args: list[str]) -> str:
    args_str = ", ".join(args)
    ret_line = (
        f"    auto result = sol.{sig.method}({args_str});\n"
        "    (void)result;\n"
        if sig.return_type.strip() != "void" else
        f"    sol.{sig.method}({args_str});\n"
    )
    return (
        "// LC-energy test suite (C++) — hardcoded single case.\n"
        "#include \"solution.cpp\"\n"
        "#include <vector>\n"
        "#include <string>\n"
        "int main() {\n"
        "    Solution sol;\n"
        f"{ret_line}"
        "    return 0;\n"
        "}\n"
    )


def emit_csharp_suite(sig: Sig, args: list[str]) -> str:
    args_str = ", ".join(args)
    call_line = (
        f"        var result = sol.{sig.method}({args_str});\n"
        "        if (result == null) System.Console.WriteLine(result);\n"
        if sig.return_type.strip() != "void" else
        f"        sol.{sig.method}({args_str});\n"
    )
    return (
        "// LC-energy test suite (C#) — hardcoded single case.\n"
        "public class TestSuite {\n"
        "    public static void Main() {\n"
        "        var sol = new Solution();\n"
        f"{call_line}"
        "    }\n"
        "}\n"
    )


def emit_go_suite(sig: Sig, args: list[str]) -> str:
    args_str = ", ".join(args)
    call_line = f"    _ = {sig.method}({args_str})\n"
    return (
        "// LC-energy test suite (Go) — hardcoded single case.\n"
        "package main\n\n"
        "func main() {\n"
        f"{call_line}"
        "}\n"
    )


def emit_rust_suite(sig: Sig, args: list[str]) -> str:
    args_str = ", ".join(args)
    # Compiled via a `cat solution.rs test_suite.rs > _combined.rs` step
    # in the Makefile — so we're in the SAME translation unit as
    # solution.rs's `impl Solution`, and the header prepends
    # `pub struct Solution;`. No `mod`/`use` needed.
    call_line = f"    let _ = Solution::{sig.method}({args_str});\n"
    return (
        "// LC-energy test suite (Rust) — hardcoded single case.\n"
        "// Concatenated with solution.rs at compile time; header at the\n"
        "// top of _combined.rs declares `pub struct Solution;`.\n"
        "fn main() {\n"
        f"{call_line}"
        "}\n"
    )


def emit_js_suite(sig: Sig, args: list[str]) -> str:
    args_str = ", ".join(args)
    return (
        "// LC-energy test suite (JavaScript) — hardcoded single case.\n"
        "const path = require('path');\n"
        "const src = require('fs').readFileSync(path.join(__dirname,'solution.js'),'utf8');\n"
        "eval(src);\n"
        f"const _ = {sig.method}({args_str});\n"
    )


def emit_ts_suite(sig: Sig, args: list[str]) -> str:
    args_str = ", ".join(args)
    # Files are concatenated (`cat solution.ts test_suite.ts > combined.ts`)
    # before tsc runs, so the entry-point function is in scope. No
    # `declare` needed — that would duplicate the definition.
    return (
        "// LC-energy test suite (TypeScript) — hardcoded single case.\n"
        f"const _lc_test_result = {sig.method}({args_str});\n"
        "if (_lc_test_result === undefined || _lc_test_result === null) {\n"
        "    console.log('void return');\n"
        "}\n"
    )


def emit_php_suite(sig: Sig, args: list[str]) -> str:
    args_str = ", ".join(args)
    return (
        "<?php\n"
        "// LC-energy test suite (PHP) — hardcoded single case.\n"
        "require_once 'solution.php';\n"
        "$sol = new Solution();\n"
        f"$_ = $sol->{sig.method}({args_str});\n"
    )


def emit_ruby_suite(sig: Sig, args: list[str]) -> str:
    args_str = ", ".join(args)
    return (
        "# LC-energy test suite (Ruby) — hardcoded single case.\n"
        "require_relative 'solution'\n"
        f"_ = {sig.method}({args_str})\n"
    )


EMITTERS = {
    "Python":     emit_python_suite,
    "Java":       emit_java_suite,
    "C++":        emit_cpp_suite,
    "CSharp":     emit_csharp_suite,
    "Go":         emit_go_suite,
    "Rust":       emit_rust_suite,
    "JavaScript": emit_js_suite,
    "TypeScript": emit_ts_suite,
    "PHP":        emit_php_suite,
    "Ruby":       emit_ruby_suite,
}


# ---------- Makefile template ---------------------------------------------

def emit_makefile(lang_folder: str, slug: str) -> str:
    L = LANGS[lang_folder]
    source_filename = f"solution.{L.ext}"
    compile_cmd = L.compile_cmd or "# no separate compile (interpreted)"
    return f"""# LC-energy {slug} ({lang_folder}) — CLBG-shape.
# Auto-generated by scripts/generate_lc_cells.py.
#
# Correctness is validated separately; this cell exists ONLY for perf
# measurement. perfarena.mk's compile / run / measure / mem targets do
# the work — the profiler (codecarbon / powermetrics / RAPL, selected
# by PERFARENA_PROFILER) wraps RUN_CMD once per measure iteration.
LANG        = {lang_folder}
TEST        = {slug}
SOURCE      = {source_filename}
OUTPUT      = {L.output_artifact}
ARG         =
RUN_CMD     = {L.run_cmd}
COMPILE_CMD = {compile_cmd}

# validate: permanent PASS via empty-stream compare. Real correctness
# is owned by whatever oracle the arena binds to this competition.
VALIDATION_N     = $(ARG)
REFERENCE_OUTPUT = /dev/null
BINARY_OUTPUT    = 1

CC     ?= gcc
CXX    ?= g++
JAVAC  ?= javac
GO     ?= go
RUSTC  ?= rustc
CSC    ?= csc

include ../../../perfarena.mk
"""


# ---------- driver --------------------------------------------------------

def _default_args(lang_folder: str, sig: Sig) -> list[str]:
    return [default_literal(lang_folder, ty) for _, ty in sig.params]


def _is_design_snippet(snippet: str) -> bool:
    """A LeetCode 'design' problem ships a class with a constructor that is
    instantiated and driven by an operation sequence (e.g. MKAverage,
    StreamChecker, CustomStack). LC marks these with a boilerplate comment in
    the starter snippet. Their class is NOT named `Solution`, so the standard
    smoke test can't compile — the cell keeps a compile-only gate instead."""
    return ("instantiated and called as such" in snippet
            or "will be instantiated" in snippet)


def process_cell(lang_folder: str, slug: str, dry_run: bool, overwrite: bool
                 ) -> tuple[str, str]:
    """Return (slug, status). status is 'wrote', 'skipped: <reason>', or 'already-exists'."""
    L = LANGS[lang_folder]
    cell = ROOT / lang_folder / "leetcode" / slug
    if not cell.is_dir():
        return slug, "skip: cell dir missing"
    pj = cell / "problem.json"
    if not pj.exists():
        return slug, "skip: no problem.json"
    problem = json.loads(pj.read_text())
    snippets = problem.get("code_snippets") or {}
    snippet = snippets.get(L.key)
    if not snippet:
        return slug, f"skip: no code_snippets[{L.key}]"

    if _is_design_snippet(snippet):
        # Design problems (a class with a constructor invoked as an operation
        # sequence, e.g. MKAverage/StreamChecker) can't use the standard
        # `new Solution().method()` smoke test — the class isn't named
        # `Solution`, so parsing grabs the constructor and the generated suite
        # fails to compile. These cells' test suites are compile-only gates,
        # hand-maintained; correctness comes from the leetcode oracle and
        # measurement from the design-aware selection/ harness. Skip so a regen
        # never clobbers them with a broken Solution-shaped suite.
        return slug, "skip: design problem (test suite hand-maintained)"

    try:
        sig = PARSERS[lang_folder](snippet)
    except Skip as e:
        return slug, f"skip parse: {e}"
    try:
        args = _default_args(lang_folder, sig)
    except Skip as e:
        return slug, f"skip type: {e}"

    suite_body = EMITTERS[lang_folder](sig, args)
    makefile_body = emit_makefile(lang_folder, slug)

    suite_path = cell / L.suite_filename
    mk_path = cell / "Makefile"

    if not dry_run:
        if suite_path.exists() and not overwrite:
            return slug, "already-exists: suite present"
        suite_path.write_text(suite_body)
        mk_path.write_text(makefile_body)
    return slug, "wrote"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--languages", default="",
                    help="Comma-separated folder names (default: all 10).")
    ap.add_argument("--slugs", default="",
                    help="Comma-separated slugs (default: all present).")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--overwrite", action="store_true",
                    help="Overwrite existing test_suite files (Makefiles are always rewritten).")
    args = ap.parse_args()

    langs = (
        [x.strip() for x in args.languages.split(",") if x.strip()]
        if args.languages else list(LANGS)
    )
    for lang in langs:
        if lang not in LANGS:
            print(f"unknown language: {lang} (known: {sorted(LANGS)})", file=sys.stderr)
            return 2

    per_lang_slugs: dict[str, list[str]] = {}
    for lang in langs:
        d = ROOT / lang / "leetcode"
        if not d.is_dir(): continue
        slugs = sorted(p.name for p in d.iterdir() if (p / "problem.json").exists())
        if args.slugs:
            wanted = {s.strip() for s in args.slugs.split(",") if s.strip()}
            slugs = [s for s in slugs if s in wanted]
        per_lang_slugs[lang] = slugs

    total_wrote = 0
    total_skipped = 0
    for lang in langs:
        slugs = per_lang_slugs.get(lang, [])
        wrote, skipped = [], []
        for slug in slugs:
            _, st = process_cell(lang, slug, dry_run=args.dry_run,
                                 overwrite=args.overwrite)
            if st == "wrote":
                wrote.append(slug)
            elif st.startswith("already-exists"):
                pass
            else:
                skipped.append((slug, st))
        total_wrote += len(wrote)
        total_skipped += len(skipped)
        print(f"{lang:12}  wrote={len(wrote):3}  skipped={len(skipped):3}  "
              f"total={len(slugs):3}")
        for slug, reason in skipped[:3]:
            print(f"  {slug}: {reason[:100]}")
        if len(skipped) > 3:
            print(f"  … +{len(skipped)-3} more skips")

    print(f"\n{'-'*60}")
    print(f"TOTAL wrote={total_wrote}  skipped={total_skipped}"
          f"{'  (dry-run)' if args.dry_run else ''}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
