#!/usr/bin/env python3
"""LC loop-harness (new methodology) — BESPOKE for random-pick-index.

This is a DESIGN-class problem: a Solution(nums) object is constructed, then a
sequence of pick(target) calls is replayed. pick() is RANDOMIZED, so there is no
fixed expected index. Instead correctness is a VALIDITY check: for a correct
solution the value at the returned index equals the target, so the "solve"
computes  [None] + [nums[returned_index] for each pick]  which is deterministic
(== the stored output [None, target1, target2, ...]) for any correct solution.

Usage:  python3 test_suite.py <budget_seconds> <case_index>
  - derives the slug from the containing directory name
  - loads the SHARED serialized design input from
      reference/leetcode/{workloads,outputs}/<slug>.json
    ops  = ["Solution","pick","pick",...]
    args = [[nums], [target1], [target2], ...]
  - replays the op sequence (one solve = one full replay) until <budget>
    seconds elapse, deepcopy-ing the args each iteration for mutation safety,
    folding each solve's result into a checksum. Result -> STDERR (stdout empty).
"""
import sys, os, json, time, copy, importlib.util

CELL = os.path.dirname(os.path.abspath(__file__))
SLUG = os.path.basename(CELL)
REF  = os.path.normpath(os.path.join(CELL, "..", "..", "..", "reference", "leetcode"))

def load_case(slug, idx):
    o = json.load(open(os.path.join(REF, "outputs", slug + ".json")))
    cases = o["expected"]
    c = cases[idx]
    return c["name"], c["input"]["ops"], c["input"]["args"], len(cases)

def load_solution():
    spec = importlib.util.spec_from_file_location("solution", os.path.join(CELL, "solution.py"))
    mod = importlib.util.module_from_spec(spec); import typing as _ty; mod.__dict__.update({k: getattr(_ty, k) for k in _ty.__all__}); spec.loader.exec_module(mod)
    return mod.Solution

def solve(Solution, ops, args):
    """Replay the design op sequence once; return validity-marker list.

    For the constructor -> None; for each pick(target) -> nums[returned_index]
    (which must equal target for a correct solution). Deterministic despite the
    randomized index choice, so it doubles as the correctness beacon.
    """
    nums = args[0][0]
    obj = Solution(nums)
    out = [None]
    for op, a in zip(ops[1:], args[1:]):
        target = a[0]
        i = obj.pick(target)
        out.append(nums[i])   # value at returned index == validity marker
    return out

def fold(acc, r):
    return (acc * 1000003 + (hash(repr(r)) & 0xFFFFFFFF)) & ((1 << 62) - 1)

def main():
    budget = float(sys.argv[1]) if len(sys.argv) > 1 else 1.0
    idx    = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    name, ops, args, ncases = load_case(SLUG, idx)
    Solution = load_solution()
    # (1) A FRESH Solution is built inside solve() every replay (object state is
    #     always clean); the per-iteration deepcopy only protected `args`. Detect
    #     once whether solve mutates args and, if not, pass it directly. (pick()
    #     is randomized but nums[returned_index] == target, so the marker list is
    #     deterministic across iterations.)
    args_snap = copy.deepcopy(args)
    r0 = solve(Solution, ops, args)                    # correctness beacon
    mutated = (args != args_snap)
    if mutated:
        args = copy.deepcopy(args_snap)

    def one():
        return solve(Solution, ops, copy.deepcopy(args)) if mutated else solve(Solution, ops, args)

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
