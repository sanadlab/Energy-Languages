#!/usr/bin/env python3
"""Generic LC loop-harness (new methodology), identical in every Python cell.

Usage:  python3 test_suite.py <budget_seconds> <case_index>
  - derives the problem slug from the containing directory name
  - loads the SHARED, language-independent input for that case from
    reference/leetcode/{workloads,outputs}/<slug>.json  (single source of truth)
  - loops solution(<case>) until <budget> seconds elapse, folding each result
    into a checksum (consumed -> no dead work), and prints the iteration count.
Steady-state per-op = budget / ITERS ; energy is attributed by the driver that
wraps this invocation. Same inputs across languages => cross-language comparable.
"""
import sys, os, json, time, copy, importlib.util

CELL = os.path.dirname(os.path.abspath(__file__))
SLUG = os.path.basename(CELL)
REF  = os.path.normpath(os.path.join(CELL, "..", "..", "..", "reference", "leetcode"))

def load_case(slug, idx):
    w = json.load(open(os.path.join(REF, "workloads", slug + ".json")))
    ep = (w.get("entry_point") or "").strip()          # e.g. "Solution().lengthOfLIS"
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

def fold(acc, r):
    # C-level repr is the cheapest fold in CPython (a pure-Python structural
    # checksum is 3-6x slower); results are small so this is negligible.
    return (acc * 1000003 + (hash(repr(r)) & 0xFFFFFFFF)) & ((1 << 62) - 1)

def main():
    budget = float(sys.argv[1]) if len(sys.argv) > 1 else 1.0
    idx    = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    method, name, args, ncases = load_case(SLUG, idx)
    fn = resolve_fn(method)

    # --- Overhead reduction (measure the solution, not the harness) ----------
    # (1) Detect once whether the solution mutates its input. Most LC solutions
    #     don't; for those we call on the SHARED args and skip copy.deepcopy
    #     entirely (deepcopy was 40-85% of measured time on cheap solutions).
    #     Only genuinely-mutating solutions still pay the per-iteration clone.
    snapshot = copy.deepcopy(args)
    r0 = fn(*args)                                      # pristine call -> beacon
    mutated = (args != snapshot)
    if mutated:
        args = copy.deepcopy(snapshot)                 # restore pristine input

    def one():
        return fn(*copy.deepcopy(args)) if mutated else fn(*args)

    # Warmup (uncounted) 30% of budget, then measure 70% — matches the
    # warmup/measure split of the other 9 language harnesses (D5). The warmup
    # also estimates per-iteration cost so we can (3) batch the wall-clock read.
    warm = budget * 0.3
    wi = 0
    tw = time.perf_counter()
    while time.perf_counter() - tw < warm:
        one(); wi += 1
    per_iter = (time.perf_counter() - tw) / wi if wi else warm
    # target ~2ms between clock reads -> clock overhead <1%, overshoot <=2ms
    batch = max(1, min(4096, int(0.002 / per_iter))) if per_iter > 0 else 4096

    acc, iters = 0, 0
    window = budget - warm
    t0 = time.perf_counter()
    while time.perf_counter() - t0 < window:
        for _ in range(batch):
            acc = fold(acc, one())
        iters += batch
    meas = time.perf_counter() - t0
    # Results go to STDERR so stdout stays empty -> the cell's existing
    # `make validate` (empty-output vs /dev/null) still passes and the arena
    # bridge is unaffected. The driver parses ITERS/BEACON from stderr.
    sys.stderr.write("CASE=%s NCASES=%d ITERS=%d ACC=%d MEAS_S=%.6f BEACON=%s\n"
                     % (name, ncases, iters, acc, meas, repr(r0)[:48]))

main()
