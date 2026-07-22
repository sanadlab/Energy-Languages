"""Derive reference/leetcode/outputs/<slug>.json from each workload's `test`
function so `perfarena leetcode-workload-run` can validate.

The workloads at reference/leetcode/workloads/*.json already carry the
ground truth in a `test` field of the shape

    def check(candidate):
        assert candidate(n = 3) == 3
        assert candidate(n = 12) == 7
        ...

We parse the AST of that function, pull out every top-level assert
`candidate(<kwargs>) == <literal>`, and emit an outputs file with:

    { "workload_hash": <copy of workload's>,
      "expected":      [ {"name": "case_1", "input": {"n": 3}, "output": 3}, ... ] }

Any workload whose test uses expressions we can't statically evaluate
(external helpers, list comprehensions on the RHS, etc.) is SKIPPED and
reported at the end — nothing is left half-populated on disk.

Usage:
    .venv-runner/bin/python scripts/derive_leetcode_outputs.py         # write for all
    .venv-runner/bin/python scripts/derive_leetcode_outputs.py --dry-run
    .venv-runner/bin/python scripts/derive_leetcode_outputs.py two-sum three-sum
"""
from __future__ import annotations

import argparse
import ast
import hashlib
import json
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent.parent
WORKLOADS = ROOT / "reference" / "leetcode" / "workloads"
OUTPUTS = ROOT / "reference" / "leetcode" / "outputs"


@dataclass
class DerivedCase:
    name: str
    input: dict[str, Any]
    output: Any


class Skip(Exception):
    """Raised when we can't safely derive a problem's outputs."""


def _extract_test_source(workload: dict) -> str:
    src = workload.get("test")
    if not isinstance(src, str) or "def check(candidate)" not in src:
        raise Skip("workload has no `test` function or wrong shape")
    return src


def _parse_check_function(src: str) -> ast.FunctionDef:
    tree = ast.parse(src)
    for node in tree.body:
        if isinstance(node, ast.FunctionDef) and node.name == "check":
            return node
    raise Skip("no `check` function at module level")


def _literal(node: ast.AST) -> Any:
    """Statically evaluate a Python AST node to its value. Only accepts
    literal-safe subtrees — no calls, no names, no attributes."""
    # ast.literal_eval handles numbers, strings, lists, dicts, tuples,
    # booleans, None. `-1` is a UnaryOp(USub) around a Constant — literal_eval
    # supports that too.
    try:
        return ast.literal_eval(node)
    except (ValueError, SyntaxError) as e:
        raise Skip(f"non-literal expression at line {node.lineno}: {e}") from None


def _extract_cases_from_asserts(func: ast.FunctionDef) -> list[DerivedCase]:
    """Walk asserts of form `assert candidate(<kwargs>) == <literal>` and
    convert each to a DerivedCase. Positional args are folded into an
    `arg0`, `arg1` … keyword scheme so downstream code can always call
    with **kwargs."""
    cases: list[DerivedCase] = []
    for i, stmt in enumerate(func.body, start=1):
        if not isinstance(stmt, ast.Assert):
            raise Skip(f"non-assert statement at line {stmt.lineno}")
        cmp = stmt.test
        if (not isinstance(cmp, ast.Compare)
                or len(cmp.ops) != 1
                or not isinstance(cmp.ops[0], ast.Eq)):
            raise Skip(f"non-`==` assertion at line {stmt.lineno}")
        left = cmp.left
        right = cmp.comparators[0]
        if not (isinstance(left, ast.Call)
                and isinstance(left.func, ast.Name)
                and left.func.id == "candidate"):
            raise Skip(f"assert LHS isn't `candidate(...)` at line {stmt.lineno}")
        input_dict: dict[str, Any] = {}
        for kw in left.keywords:
            if kw.arg is None:                     # **kwargs unpack — bail
                raise Skip(f"**kwargs at line {stmt.lineno}")
            input_dict[kw.arg] = _literal(kw.value)
        for j, arg in enumerate(left.args):
            input_dict[f"arg{j}"] = _literal(arg)
        expected = _literal(right)
        cases.append(DerivedCase(
            name=f"case_{i}", input=input_dict, output=expected,
        ))
    if not cases:
        raise Skip("no assertions found")
    return cases


def derive(slug: str, dry_run: bool) -> tuple[str, int | str]:
    """Return (slug, n_cases) on success or (slug, "skip: <reason>")."""
    wp = WORKLOADS / f"{slug}.json"
    if not wp.exists():
        return slug, "skip: workload file not found"
    workload = json.loads(wp.read_text())
    try:
        src = _extract_test_source(workload)
        func = _parse_check_function(src)
        cases = _extract_cases_from_asserts(func)
    except Skip as e:
        return slug, f"skip: {e}"

    payload = {
        "workload_hash": workload.get("workload_hash"),
        "problem":       slug,
        "expected": [
            {"name": c.name, "input": c.input, "output": c.output}
            for c in cases
        ],
    }
    if not dry_run:
        OUTPUTS.mkdir(parents=True, exist_ok=True)
        (OUTPUTS / f"{slug}.json").write_text(json.dumps(payload, indent=2))
    return slug, len(cases)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("slugs", nargs="*",
                    help="Problem slugs to process (default: all workloads).")
    ap.add_argument("--dry-run", action="store_true",
                    help="report only, don't write files")
    args = ap.parse_args()

    if args.slugs:
        slugs = list(args.slugs)
    else:
        slugs = sorted(p.stem for p in WORKLOADS.glob("*.json"))
    print(f"deriving outputs for {len(slugs)} workload(s)"
          f"{' (dry-run)' if args.dry_run else ''}…")

    ok, skipped = [], []
    for slug in slugs:
        _, r = derive(slug, dry_run=args.dry_run)
        if isinstance(r, int):
            ok.append((slug, r))
        else:
            skipped.append((slug, r))

    print(f"\n{'-'*60}")
    print(f"WROTE {len(ok)} outputs file(s){' (dry-run)' if args.dry_run else ''}")
    print(f"SKIPPED {len(skipped)} workload(s)")
    for slug, reason in skipped[:15]:
        print(f"  {slug}: {reason[:80]}")
    if len(skipped) > 15:
        print(f"  … +{len(skipped) - 15} more")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
