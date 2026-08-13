#!/usr/bin/env python3
"""New-methodology measurement driver (language-agnostic; Python wired first).

For one problem: select a few cases spanning input sizes, then for each case
invoke the cell's loop-harness (which loops that case to <budget>s) wrapped in
codecarbon, and report per-case throughput + energy-per-op.

  usage: lc_measure.py <slug> [budget=1.0] [k=3] [lang=python]

Case selection here is a size-spread placeholder for the fingerprint/medoid
selector (Phase 2); the harness + measurement contract are what this proves.
Energy on macOS is a TDP-estimate via codecarbon; real numbers = Linux+RAPL.
"""
import sys, os, json, re, subprocess, statistics
ROOT = "/Users/rar9993/repos/research/leetcode_crawler/Energy-Languages"
REF  = os.path.join(ROOT, "reference", "leetcode")

LANG = {  # arena-lang -> (cell folder, run-command builder given cell dir)
  "python": ("Python", lambda cell: ["python3", "test_suite.py"]),
}

def cases_for(slug):
    o = json.load(open(os.path.join(REF, "outputs", slug + ".json")))
    out = []
    for i, c in enumerate(o["expected"]):
        size = len(json.dumps(c["input"]))
        out.append((i, c["name"], size))
    return out

def select(cases, k):
    """Span the size range: sort by size, take k evenly-spaced picks."""
    s = sorted(cases, key=lambda x: x[2])
    if len(s) <= k: return s
    idxs = [round(j*(len(s)-1)/(k-1)) for j in range(k)]
    return [s[j] for j in sorted(set(idxs))]

def tracker():
    try:
        from codecarbon import EmissionsTracker
        return lambda: EmissionsTracker(save_to_file=False, log_level="error",
                                        measure_power_secs=1, allow_multiple_runs=True)
    except Exception:
        return None
MK = tracker()

def measure_case(cell, runcmd, budget, idx):
    energy_j = None
    if MK:
        t = MK(); t.start()
        p = subprocess.run(runcmd + [str(budget), str(idx)], cwd=cell, capture_output=True, text=True)
        energy_j = (t.stop() or 0.0) * 3.6e6
    else:
        p = subprocess.run(runcmd + [str(budget), str(idx)], cwd=cell, capture_output=True, text=True)
    blob = p.stdout + p.stderr
    m = re.search(r"ITERS=(\d+)", blob); b = re.search(r"BEACON=(\S.*)$", blob)
    it = int(m.group(1)) if m else None
    return it, energy_j, (b.group(1) if b else None), p.stderr

def main():
    slug   = sys.argv[1]
    budget = float(sys.argv[2]) if len(sys.argv) > 2 else 1.0
    k      = int(sys.argv[3]) if len(sys.argv) > 3 else 3
    lang   = sys.argv[4] if len(sys.argv) > 4 else "python"
    folder, runb = LANG[lang]
    cell = os.path.join(ROOT, folder, "leetcode", slug)
    runcmd = runb(cell)
    picks = select(cases_for(slug), k)
    print(f"# {slug} [{lang}] budget={budget}s  selected {len(picks)} cases (size-spread of {len(cases_for(slug))})")
    print(f"{'case':<10}{'inp.size':>9}{'iters':>10}{'µs/op':>12}{'µJ/op(est)':>13}  beacon")
    for idx, name, size in picks:
        it, ej, beacon, err = measure_case(cell, runcmd, budget, idx)
        if not it:
            print(f"{name:<10}{size:>9}   RUN FAIL: {err[-120:]}"); continue
        us = budget/it*1e6
        uj = (ej/it*1e6) if ej else float('nan')
        print(f"{name:<10}{size:>9}{it:>10}{us:>12.3f}{uj:>13.4f}  {beacon}")

main()
