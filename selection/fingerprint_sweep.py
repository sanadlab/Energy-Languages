#!/usr/bin/env python3
"""Box-side sweep (STEP 1): per test-case perf fingerprint + RAPL energy.

For each Python problem, measure up to CAP cases (seeded-random sample if more),
each looped to BUDGET seconds by the cell's test_suite.py, wrapped in `perf stat`
for the behavior fingerprint and bracketed by RAPL energy_uj for energy.

Emits one JSONL row per (problem, case) with per-op fingerprint + energy — the
dataset the selector (step 2) clusters. Every run has a hard timeout so a
pathological solution is killed, never orphaned.

  usage: fingerprint_sweep.py [--budget 0.3] [--cap 100] [--seed 42]
                              [--out fp.jsonl] [--slugs a,b,c]
"""
import os, sys, json, glob, random, subprocess, signal, re, time, argparse

HOME = os.path.expanduser("~")
ROOT = os.path.join(HOME, "Energy-Languages")
REF  = os.path.join(ROOT, "reference", "leetcode")
CELLS= os.path.join(ROOT, "Python", "leetcode")
RAPL = "/sys/class/powercap/intel-rapl/intel-rapl:0/energy_uj"
RAPL_MAX = "/sys/class/powercap/intel-rapl/intel-rapl:0/max_energy_range_uj"
EVENTS = "instructions,cycles,cache-references,cache-misses,branches,branch-misses"

def read_rapl():
    try:
        return int(open(RAPL).read())
    except Exception:
        # fall back to sudo if not world-readable
        return int(subprocess.check_output(["sudo","cat",RAPL]))

try: RANGE = int(open(RAPL_MAX).read())
except Exception: RANGE = None

def rapl_delta(e1, e2):
    d = e2 - e1
    if d < 0 and RANGE: d += RANGE
    return d

def run_timed(argv, cwd, timeout):
    p = subprocess.Popen(argv, cwd=cwd, stdout=subprocess.DEVNULL,
                         stderr=subprocess.PIPE, text=True, start_new_session=True)
    try:
        _, err = p.communicate(timeout=timeout)
        return p.returncode, err
    except subprocess.TimeoutExpired:
        try: os.killpg(os.getpgid(p.pid), signal.SIGKILL)
        except Exception: pass
        p.communicate()
        return -9, "TIMEOUT"

def parse_perf(path):
    d = {}
    for line in open(path):
        parts = line.split(",")
        if len(parts) < 3: continue
        val, _unit, ev = parts[0], parts[1], parts[2]
        try: d[ev] = float(val)
        except ValueError: pass
    return d

def cases_for(slug):
    o = json.load(open(os.path.join(REF, "outputs", slug + ".json")))
    return [(i, c["name"], len(json.dumps(c["input"]))) for i, c in enumerate(o["expected"])]

def select(cases, cap, rng):
    if len(cases) <= cap: return cases
    return sorted(rng.sample(cases, cap), key=lambda x: x[0])

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--budget", type=float, default=0.3)
    ap.add_argument("--cap", type=int, default=100)
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--out", default=os.path.join(HOME, "lc_new", "fp.jsonl"))
    ap.add_argument("--slugs", default="")
    args = ap.parse_args()

    slugs = ([s for s in args.slugs.split(",") if s] or
             sorted(os.path.basename(f)[:-5] for f in glob.glob(os.path.join(REF,"outputs","*.json"))
                    if os.path.isdir(os.path.join(CELLS, os.path.basename(f)[:-5]))))
    rng = random.Random(args.seed)
    out = open(args.out, "w")
    t_start = time.time()
    total_cases = ok = fail = 0
    for pi, slug in enumerate(slugs):
        cell = os.path.join(CELLS, slug)
        if not os.path.isfile(os.path.join(cell, "test_suite.py")): continue
        picks = select(cases_for(slug), args.cap, rng)
        pok = 0
        for idx, name, size in picks:
            total_cases += 1
            perf_csv = "/tmp/perf_%d.csv" % idx
            e1 = read_rapl()
            rc, err = run_timed(
                ["perf","stat","-x,","-e",EVENTS,"-o",perf_csv,
                 "python3","test_suite.py",str(args.budget),str(idx)],
                cwd=cell, timeout=args.budget + 25)
            e2 = read_rapl()
            m = re.search(r"ITERS=(\d+)", err or ""); b = re.search(r"BEACON=(.*)", err or "")
            if rc != 0 or not m:
                fail += 1
                out.write(json.dumps({"problem":slug,"case":name,"idx":idx,"size":size,
                                      "status":"fail","rc":rc,"err":(err or "")[-160:]})+"\n")
                continue
            iters = int(m.group(1)); pf = parse_perf(perf_csv)
            dE = rapl_delta(e1, e2)
            row = {"problem":slug,"case":name,"idx":idx,"size":size,"status":"ok",
                   "iters":iters,"budget":args.budget,
                   "energy_uj":dE,"energy_uj_per_op":dE/iters,
                   "beacon":(b.group(1).strip() if b else None)}
            for k in ("instructions","cycles","cache-references","cache-misses","branches","branch-misses"):
                if k in pf: row[k+"_per_op"] = pf[k]/iters
            out.write(json.dumps(row)+"\n"); ok += 1; pok += 1
        out.flush()
        el = time.time()-t_start
        print(f"[{pi+1:2}/{len(slugs)}] {slug:<52} {pok}/{len(picks)} cases  "
              f"(elapsed {el/60:.1f}m, {total_cases} done)", flush=True)
    print(f"\nDONE: {ok} ok, {fail} fail, {total_cases} total in {(time.time()-t_start)/60:.1f} min")
    print(f"wrote {args.out}")

main()
