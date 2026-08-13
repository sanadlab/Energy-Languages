#!/usr/bin/env python3
"""Bespoke LC loop-harness (new methodology) for a DESIGN-class problem:
design-a-stack-with-increment-operation.

Usage:  python3 test_suite.py <budget_seconds> <case_index>
  - derives the problem slug from the containing directory name
  - loads the SHARED, language-independent input for that case from
    reference/leetcode/{workloads,outputs}/<slug>.json
  - the input is a serialized op-sequence: {"ops":[...], "args":[[...],...]}
    ops[0] is the class name (constructor); the rest are method calls.
  - "one solve" = replay the whole op-sequence on a FRESH object and collect
    the list of returns (None for void methods). Loops the solve until <budget>
    seconds elapse, folding each result into a checksum, and prints the count.

Results go to STDERR so stdout stays empty (the cell's `make validate`
empty-stream compare still passes). The driver parses ITERS/BEACON from stderr.
"""
import sys, os, json, time, copy, importlib.util

CELL = os.path.dirname(os.path.abspath(__file__))
SLUG = os.path.basename(CELL)
REF  = os.path.normpath(os.path.join(CELL, "..", "..", "..", "reference", "leetcode"))

CLS = "CustomStack"  # constructor / class name used in the serialized op-sequence


def load_case(slug, idx):
    o = json.load(open(os.path.join(REF, "outputs", slug + ".json")))
    cases = o["expected"]
    c = cases[idx]
    return c["name"], c["input"]["ops"], c["input"]["args"], len(cases)


def load_class():
    spec = importlib.util.spec_from_file_location("solution", os.path.join(CELL, "solution.py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return getattr(mod, CLS)


def replay(Cls, ops, args):
    """Replay the op-sequence on a fresh object; return list of returns (None for void)."""
    out = []
    obj = None
    for op, a in zip(ops, args):
        if op == CLS:
            obj = Cls(*a)
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
    Cls = load_class()

    # (1) A FRESH object is built inside replay() every call, so object state is
    #     always clean; the per-iteration deepcopy only protected the ops/args.
    #     Detect once whether replay mutates them and, if not, pass them directly.
    ops_snap = copy.deepcopy(ops)
    args_snap = copy.deepcopy(args)
    r0 = replay(Cls, ops, args)                        # correctness beacon
    mutated = (ops != ops_snap) or (args != args_snap)
    if mutated:
        ops = copy.deepcopy(ops_snap)
        args = copy.deepcopy(args_snap)

    def one():
        if mutated:
            return replay(Cls, copy.deepcopy(ops), copy.deepcopy(args))
        return replay(Cls, ops, args)

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
