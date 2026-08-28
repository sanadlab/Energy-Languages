#!/usr/bin/env python3
"""LC loop-harness (new methodology) for restore-the-array-from-adjacent-pairs.

Usage:  python3 test_suite.py <budget_seconds> <case_index>

Same contract as the generic Python harness, but with a problem-specific
CANONICALIZATION step: the restored array may be returned forwards or reversed
and LeetCode accepts either.  We canonicalize to "smaller-endpoint-first" before
folding into the checksum and before emitting the BEACON, so results are
direction-independent (stable across languages / implementations) and the BEACON
matches the canonical `output` stored in reference/leetcode/outputs/<slug>.json.

Loads the SHARED, language-independent input for a case from
reference/leetcode/{workloads,outputs}/<slug>.json (single source of truth),
loops the solve until <budget> seconds elapse (deepcopy of args each iteration
for mutation safety), folds each canonicalized result into a checksum, and writes
`CASE=.. NCASES=.. ITERS=.. ACC=.. BEACON=..` to STDERR (stdout stays empty so
`make validate` still passes).
"""
import sys, os, json, time, copy, importlib.util

CELL = os.path.dirname(os.path.abspath(__file__))
SLUG = os.path.basename(CELL)
REF  = os.path.normpath(os.path.join(CELL, "..", "..", "..", "reference", "leetcode"))

def load_case(slug, idx):
    w = json.load(open(os.path.join(REF, "workloads", slug + ".json")))
    ep = (w.get("entry_point") or "").strip()          # e.g. "Solution().restoreArray"
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

def canon(res):
    # smaller-endpoint-first: either direction is a valid restoration
    if isinstance(res, list) and len(res) >= 2 and res[0] > res[-1]:
        return res[::-1]
    return res

def fold(acc, r):
    return (acc * 1000003 + (hash(repr(r)) & 0xFFFFFFFF)) & ((1 << 62) - 1)

def main():
    budget = float(sys.argv[1]) if len(sys.argv) > 1 else 1.0
    idx    = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    method, name, args, ncases = load_case(SLUG, idx)
    fn = resolve_fn(method)

    # (1) Detect once whether the solution mutates its input; skip the
    #     per-iteration clone when it does not (deepcopy dominated cheap cells).
    #     The direction-canonicalization wrapper (canon) is preserved.
    snapshot = copy.deepcopy(args)
    r0 = canon(fn(*args))                              # correctness beacon (canonicalized)
    mutated = (args != snapshot)
    if mutated:
        args = copy.deepcopy(snapshot)                # restore pristine input

    def one():
        return canon(fn(*copy.deepcopy(args))) if mutated else canon(fn(*args))

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
