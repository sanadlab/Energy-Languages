#!/usr/bin/env python3
"""Bespoke LC loop-harness (new methodology) for a DESIGN-class problem.

Usage:  python3 test_suite.py <budget_seconds> <case_index>

The generic harness only knows how to call Solution().<method>(*args) for a
single plain-data method, so it cannot drive a design class whose behaviour is a
*sequence* of constructor + method calls. This bespoke harness:
  - derives the slug from the directory name,
  - loads the SHARED input for that case from
    reference/leetcode/outputs/<slug>.json  (single source of truth),
  - the input is stored in standard LC serialized design form:
        {"ops":["StreamChecker","query","query",...],
         "args":[[[words...]], ["a"], ["b"], ...]}
  - one "solve" == replay the whole op sequence (build the StreamChecker, run
    every query) and collect the returns as [None, bool, bool, ...],
  - runs one solve as a correctness beacon (asserted against the stored output),
  - then loops the solve until <budget> seconds elapse, deep-copying the args
    each iteration for mutation safety and folding each result into a checksum,
  - prints CASE/NCASES/ITERS/ACC/BEACON to STDERR (stdout stays empty so the
    cell's `make validate` still passes).
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
    return c["name"], inp["ops"], inp["args"], c.get("output"), len(cases)

def resolve_class():
    spec = importlib.util.spec_from_file_location("solution", os.path.join(CELL, "solution.py"))
    mod = importlib.util.module_from_spec(spec); import typing as _ty; mod.__dict__.update({k: getattr(_ty, k) for k in _ty.__all__}); spec.loader.exec_module(mod)
    return mod.Solution  # StreamChecker is aliased to Solution in solution.py

def replay(cls, ops, args):
    """Execute the serialized design op sequence, returning the list of results
    (None for the constructor, then one value per method call)."""
    obj = cls(*args[0])
    out = [None]
    for op, a in zip(ops[1:], args[1:]):
        out.append(getattr(obj, op)(*a))
    return out

def fold(acc, r):
    return (acc * 1000003 + (hash(repr(r)) & 0xFFFFFFFF)) & ((1 << 62) - 1)

def main():
    budget = float(sys.argv[1]) if len(sys.argv) > 1 else 1.0
    idx    = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    name, ops, args, expected, ncases = load_case(SLUG, idx)
    cls = resolve_class()

    # (1) A FRESH object is built inside replay() every call, so object state is
    #     always clean; the per-iteration deepcopy only protected the ops/args.
    #     Detect once whether replay mutates them and, if not, pass them directly.
    ops_snap = copy.deepcopy(ops)
    args_snap = copy.deepcopy(args)
    r0 = replay(cls, ops, args)                        # correctness beacon
    if expected is not None and r0 != expected:
        sys.stderr.write("MISMATCH case=%s\n" % name)
        sys.exit(1)
    mutated = (ops != ops_snap) or (args != args_snap)
    if mutated:
        ops = copy.deepcopy(ops_snap)
        args = copy.deepcopy(args_snap)

    def one():
        if mutated:
            return replay(cls, copy.deepcopy(ops), copy.deepcopy(args))
        return replay(cls, ops, args)

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
