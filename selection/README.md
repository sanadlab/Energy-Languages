# Test-case selection pipeline & outputs

Reduced test-case set for energy benchmarking (see ../../TEST_CASE_SELECTION_PLAN.md).

## Artifacts
- `curated_selection.json` — THE reduced set: per problem, the kept cases with
  role (medoid / worst-case), cluster, weight (medoids sum to 1.0), size, energy.
- `fp_all.jsonl` — the fingerprint+RAPL-energy dataset (per (problem,case) row),
  measured on a bare-metal Intel Linux box (perf counters + RAPL, 0.3s loop budget).

## Pipeline (run on the measurement box; needs perf + RAPL + numpy/sklearn)
1. `test_suite.py` — generic loop-harness in each Python cell (shared inputs,
   loop-to-budget, checksum sink, ITERS/BEACON to stderr).
2. `fingerprint_sweep.py --budget 0.3 --cap 100 --seed 42 --out fp.jsonl`
   — per-case perf fingerprint + RAPL energy (cap 100 cases/problem, seeded sample).
3. `curate.py fp_all.jsonl --out curated_selection.json`
   — cluster (PCA -> k-means, k by silhouette) -> medoids + weights + worst-case.
4. `select_cases.py` / `fair_compare.py` — analysis (medoid overlap; fingerprint-
   vs-size clustering ARI: mean 0.54, ~41/99 problems differ meaningfully).

## Headline
8,063 measured cases -> 325 kept (4%, ~25x). Fingerprinting differs from pure
size-sorting for ~40% of problems; used consistently for all 99.
