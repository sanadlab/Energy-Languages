"""Run one LC workload pass — used by each LC-energy cell's `make run`
target so the arena's mem step can measure peak RSS in a fresh
subprocess.

Deliberately minimal: no timing, no energy tracking, no per-case
reporting. The caller (perfarena_handler._measure_mem, or `/usr/bin/time -l`
in a shell) wraps this invocation and reads RUSAGE_CHILDREN. Because
this script runs in its OWN Python interpreter (fresh RUSAGE_CHILDREN
starting at 0), the peak RSS attributable to it is exactly the
solution's per-workload peak.

Usage (invoked by the Makefile):
    python3 scripts/lc_run_one_pass.py \\
        --source solution.py \\
        --workload ../../../reference/leetcode/workloads/<slug>.json
"""
from __future__ import annotations

import argparse
import ast
import json
import sys
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path


def _load_solution(source: Path):
    spec = spec_from_file_location("lc_solution", source)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"could not load solution from {source}")
    mod = module_from_spec(spec)
    spec.loader.exec_module(mod)
    if not hasattr(mod, "Solution"):
        raise RuntimeError(f"{source} has no `Solution` class")
    return mod.Solution


def _method_name(workload: dict) -> str:
    ep = workload.get("entry_point")
    if isinstance(ep, str) and "." in ep:
        return ep.rsplit(".", 1)[-1].strip()
    # Historical alt shape
    ent = workload.get("entrypoint")
    if isinstance(ent, dict) and ent.get("method"):
        return ent["method"]
    raise RuntimeError(
        "workload has no entry_point / entrypoint.method — can't dispatch"
    )


def _case_kwargs(case: dict) -> dict:
    inp = case.get("input")
    if isinstance(inp, dict):
        return inp
    if isinstance(inp, str):
        # "n = 3, target = [1,2]" → {"n": 3, "target": [1, 2]}
        out = {}
        for part in _split_top_level(inp):
            if "=" not in part:
                continue
            k, v = part.split("=", 1)
            out[k.strip()] = ast.literal_eval(v.strip())
        return out
    raise RuntimeError(f"unrecognised input shape: {inp!r}")


def _split_top_level(s: str) -> list[str]:
    """Split by commas that aren't inside brackets/braces/quotes."""
    out, depth, buf, quote = [], 0, [], None
    for ch in s:
        if quote:
            buf.append(ch)
            if ch == quote:
                quote = None
        elif ch in ('"', "'"):
            quote = ch
            buf.append(ch)
        elif ch in "([{":
            depth += 1
            buf.append(ch)
        elif ch in ")]}":
            depth -= 1
            buf.append(ch)
        elif ch == "," and depth == 0:
            out.append("".join(buf))
            buf = []
        else:
            buf.append(ch)
    if buf:
        out.append("".join(buf))
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--source", type=Path, required=True)
    ap.add_argument("--workload", type=Path, required=True)
    args = ap.parse_args()

    workload = json.loads(args.workload.read_text())
    if workload.get("skipped"):
        # Nothing to run — treat as a clean exit so `make run` succeeds
        # and the mem step just reports whatever the fresh subprocess's
        # RUSAGE_CHILDREN was (basically Python startup only).
        print("run: workload marked skipped, no cases", file=sys.stderr)
        return 0
    Solution = _load_solution(args.source)
    method = _method_name(workload)
    fn = getattr(Solution(), method)
    for case in workload["cases"]:
        fn(**_case_kwargs(case))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
