#!/usr/bin/env python3
"""Bespoke LC loop-harness (new methodology) for a DESIGN-class problem.

finding-mk-average is a design problem: a `MKAverage` object is constructed and
then a sequence of method calls (addElement / calculateMKAverage) is replayed
against it. The generic harness can only call a single free method, so this cell
ships its own harness that:
  - derives the slug from the containing directory name
  - loads the SHARED, language-independent case from
    reference/leetcode/outputs/<slug>.json  (input = {"ops":[...], "args":[[...]]})
  - defines one "solve" = build a fresh Solution and replay the whole op sequence,
    returning the list of per-op results (None for ctor/void ops)
  - runs one solve as a correctness beacon, then loops solve() until <budget>
    seconds elapse (deepcopy of the parsed ops/args each iteration for mutation
    safety), folding each result list into a checksum (consumed -> no dead work)
  - writes CASE/NCASES/ITERS/ACC/BEACON to STDERR so stdout stays empty and the
    cell's `make validate` (empty-output vs /dev/null) still passes.

Usage:  python3 test_suite.py <budget_seconds> <case_index>
"""
import sys, os, json, time, copy, importlib.util

CELL = os.path.dirname(os.path.abspath(__file__))
SLUG = os.path.basename(CELL)
REF  = os.path.normpath(os.path.join(CELL, "..", "..", "..", "reference", "leetcode"))

def load_case(slug, idx):
    o = json.load(open(os.path.join(REF, "outputs", slug + ".json")))
    cases = o["expected"]
    c = cases[idx]
    inp = c["input"]
    return c["name"], inp["ops"], inp["args"], len(cases)

def resolve_solution():
    spec = importlib.util.spec_from_file_location("solution", os.path.join(CELL, "solution.py"))
    mod = importlib.util.module_from_spec(spec); spec.loader.exec_module(mod)
    return mod.Solution

def replay(Solution, ops, args):
    """One solve: construct on op 0, replay the rest; return list of results."""
    obj = None
    out = []
    for i, op in enumerate(ops):
        a = args[i]
        if i == 0:                       # constructor op (class name)
            obj = Solution(*a)
            out.append(None)
        else:
            out.append(getattr(obj, op)(*a))
    return out

def fold(acc, r):
    return (acc * 1000003 + (hash(repr(r)) & 0xFFFFFFFF)) & ((1 << 62) - 1)

def main():
    budget = float(sys.argv[1]) if len(sys.argv) > 1 else 1.0
    idx    = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    name, ops, args, ncases = load_case(SLUG, idx)
    Solution = resolve_solution()

    # (1) A FRESH Solution is built inside replay() every call (object state is
    #     always clean); the per-iteration deepcopy only protected `args`. Detect
    #     once whether replay mutates args and, if not, pass it directly.
    args_snap = copy.deepcopy(args)
    r0 = replay(Solution, ops, args)                   # correctness beacon
    mutated = (args != args_snap)
    if mutated:
        args = copy.deepcopy(args_snap)

    def one():
        return replay(Solution, ops, copy.deepcopy(args)) if mutated else replay(Solution, ops, args)

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
