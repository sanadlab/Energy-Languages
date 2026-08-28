#!/usr/bin/env python3
"""Bespoke LC loop-harness for remove-invalid-parentheses (new methodology).

Usage:  python3 test_suite.py <budget_seconds> <case_index>

Same contract as the generic Python loop-harness (derives the slug from the
directory, loads the SHARED language-independent case from
reference/leetcode/{workloads,outputs}/<slug>.json, loops the solve until the
budget elapses folding results into a checksum, and reports ITERS/BEACON on
STDERR so stdout stays empty for `make validate`).

WHY BESPOKE: removeInvalidParentheses returns a LIST OF UNIQUE STRINGS whose
ORDER is undefined (the reference builds it from a Python set, so order varies
across processes with hash randomization). We therefore SORT every result
before folding it into the checksum and before emitting the correctness beacon,
making both order-independent and stable across languages/runs. The stored
`output` in outputs/<slug>.json is likewise a sorted list.
"""
import sys, os, json, time, copy, importlib.util

CELL = os.path.dirname(os.path.abspath(__file__))
SLUG = os.path.basename(CELL)
REF  = os.path.normpath(os.path.join(CELL, "..", "..", "..", "reference", "leetcode"))


def load_case(slug, idx):
    w = json.load(open(os.path.join(REF, "workloads", slug + ".json")))
    ep = (w.get("entry_point") or "").strip()          # e.g. "Solution().removeInvalidParentheses"
    method = ep.split(".")[-1] if ep else None
    o = json.load(open(os.path.join(REF, "outputs", slug + ".json")))
    cases = o["expected"]
    c = cases[idx]
    return method, c["name"], list(c["input"].values()), len(cases)


def resolve_fn(method):
    spec = importlib.util.spec_from_file_location("solution", os.path.join(CELL, "solution.py"))
    mod = importlib.util.module_from_spec(spec); import typing as _ty; mod.__dict__.update({k: getattr(_ty, k) for k in _ty.__all__}); spec.loader.exec_module(mod)
    target = mod.Solution() if hasattr(mod, "Solution") else mod
    return getattr(target, method)


def norm(r):
    # Order-independent normalization for the list-of-strings output.
    return sorted(r)


def fold(acc, r):
    return (acc * 1000003 + (hash(repr(norm(r))) & 0xFFFFFFFF)) & ((1 << 62) - 1)


def main():
    budget = float(sys.argv[1]) if len(sys.argv) > 1 else 1.0
    idx    = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    method, name, args, ncases = load_case(SLUG, idx)
    fn = resolve_fn(method)

    # (1) Detect once whether the solution mutates its input; skip the
    #     per-iteration clone when it does not (deepcopy dominated cheap cells).
    #     The result-normalization (norm = sorted) wrapper is preserved.
    snapshot = copy.deepcopy(args)
    r0 = norm(fn(*args))                                # correctness beacon (sorted)
    mutated = (args != snapshot)
    if mutated:
        args = copy.deepcopy(snapshot)                 # restore pristine input

    def one():
        return norm(fn(*copy.deepcopy(args))) if mutated else norm(fn(*args))

    # Warmup (uncounted) 30% of budget; also estimates per-iter cost so we can
    # (2) batch the wall-clock read (~2ms between reads).
    warm = budget * 0.3
    wi = 0
    tw = time.perf_counter()
    while time.perf_counter() - tw < warm:
        one(); wi += 1
    per_iter = (time.perf_counter() - tw) / wi if wi else warm
    batch = max(1, min(4096, int(0.002 / per_iter))) if per_iter > 0 else 4096

    acc, iters = 0, 0
    window = budget - warm
    t0 = time.perf_counter()
    while time.perf_counter() - t0 < window:
        for _ in range(batch):
            acc = fold(acc, one())
        iters += batch
    meas = time.perf_counter() - t0
    sys.stderr.write("CASE=%s NCASES=%d ITERS=%d ACC=%d MEAS_S=%.6f BEACON=%s\n"
                     % (name, ncases, iters, acc, meas, repr(r0)[:48]))


main()
