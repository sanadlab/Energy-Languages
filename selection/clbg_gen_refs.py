#!/usr/bin/env python3
"""Generate >=5 golden test cases per CLBG problem from the TRUSTED C++
benchmarksgame solutions.

For each problem we emit, under reference/clbg/outputs/<problem>/:
  * cases.txt   one line per case: the ARG value (arg-based problems) or
                `@<input-file>` (stdin-based problems), in order.
  * 01.out .. NN.out  the golden output for each case (bytes; cmp/diff compares).

Arg-based problems run the compiled C++ cell at several N via `make run ARG=N`.
Stdin-based problems (k-nucleotide / reverse-complement / regex-redux) read a
fasta stream; we first generate fasta at several sizes into
reference/clbg/inputs/fasta-<size>.txt, then feed each in via STDIN_FILE.

Run from the Energy-Languages root:  python3 selection/clbg_gen_refs.py
"""
import os, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CPP = os.path.join(ROOT, "C++", "clbg")
PY = os.path.join(ROOT, "Python", "clbg")   # memory-safe reference for stdin problems
OUT = os.path.join(ROOT, "reference", "clbg", "outputs")
INP = os.path.join(ROOT, "reference", "clbg", "inputs")

# arg-based: problem -> 5 small, fast, deterministic N values
ARG_CASES = {
    "n-body":         [100, 500, 1000, 2000, 5000],
    "fannkuch-redux": [5, 6, 7, 8, 9],
    "binary-trees":   [6, 8, 10, 12, 14],
    "spectral-norm":  [50, 100, 200, 500, 1000],
    "fasta":          [100, 500, 1000, 2500, 5000],
    "pidigits":       [10, 20, 27, 30, 40],
}
# stdin-based: problem -> fasta input sizes to feed
FASTA_SIZES = [1000, 2500, 5000, 7500, 10000]
STDIN_CASES = {
    "k-nucleotide":       FASTA_SIZES,
    "reverse-complement": FASTA_SIZES,
    "regex-redux":        FASTA_SIZES,
}


def _make(cell, *targets, env=None):
    e = os.environ.copy()
    if env:
        e.update(env)
    return subprocess.run(["make", "-s", *targets], cwd=cell, capture_output=True, env=e, timeout=60)


def _run_arg(cell, n):
    r = _make(cell, "run", "ARG=%d" % n)
    if r.returncode != 0:
        raise RuntimeError("run ARG=%d failed: %s" % (n, r.stderr.decode(errors="replace")[-300:]))
    return r.stdout


def _run_stdin(cell, stdin_path):
    r = _make(cell, "run", "STDIN_FILE=%s" % stdin_path)
    if r.returncode != 0:
        raise RuntimeError("run STDIN=%s failed: %s" % (stdin_path, r.stderr.decode(errors="replace")[-300:]))
    return r.stdout


def _write_case_dir(problem, cases, outputs):
    d = os.path.join(OUT, problem)
    os.makedirs(d, exist_ok=True)
    for i, data in enumerate(outputs, 1):
        open(os.path.join(d, "%02d.out" % i), "wb").write(data)
    open(os.path.join(d, "cases.txt"), "w").write("\n".join(cases) + "\n")


def main():
    # 1. fasta inputs (needed by the stdin-based problems)
    fcell = os.path.join(CPP, "fasta")
    _make(fcell, "clean", "compile")
    os.makedirs(INP, exist_ok=True)
    for size in FASTA_SIZES:
        data = _run_arg(fcell, size)
        open(os.path.join(INP, "fasta-%d.txt" % size), "wb").write(data)
        print("  input fasta-%d.txt  (%d bytes)" % (size, len(data)))
    _make(fcell, "clean")

    # 2. arg-based problems
    for problem, ns in ARG_CASES.items():
        cell = os.path.join(CPP, problem)
        if not os.path.isdir(cell):
            print("  SKIP %s (no C++ cell)" % problem); continue
        cc = _make(cell, "clean", "compile")
        if cc.returncode != 0:
            print("  SKIP %s (C++ compile failed: %s)" % (problem, cc.stderr.decode(errors='replace')[-160:])); continue
        outs = [_run_arg(cell, n) for n in ns]
        _write_case_dir(problem, [str(n) for n in ns], outs)
        _make(cell, "clean")
        print("  %-18s %d cases (N=%s)" % (problem, len(ns), ns))

    # 3. stdin-based problems — generate from the memory-safe PYTHON solution
    # (the C++ k-nucleotide bus-errors on small inputs; the benchmark is
    # deterministic so Python produces the identical golden output).
    for problem, sizes in STDIN_CASES.items():
        cell = os.path.join(PY, problem)
        if not os.path.isdir(cell):
            print("  SKIP %s (no Python cell)" % problem); continue
        cc = _make(cell, "clean", "compile")
        if cc.returncode != 0:
            print("  SKIP %s (Python compile failed)" % problem); continue
        cases, outs = [], []
        for size in sizes:
            inp = os.path.join(INP, "fasta-%d.txt" % size)
            outs.append(_run_stdin(cell, inp))
            cases.append("@fasta-%d.txt" % size)
        _write_case_dir(problem, cases, outs)
        _make(cell, "clean")
        print("  %-18s %d cases (fasta sizes=%s)" % (problem, len(sizes), sizes))


if __name__ == "__main__":
    main()
