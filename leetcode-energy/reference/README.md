# LeetCode-Energy Reference Workloads

This directory mirrors the CLBG `reference/` pattern.

- `workloads/<slug>.json` stores one self-contained curated workload, including
  cases, validation metadata, dataset provenance, and a content hash.

The files are synchronized from LeetCodeDataset93. Every language must execute
the same stored cases and reproduce the semantic validation rules. LeetCode
acceptance remains the correctness authority; these files define the local,
reproducible workload used for energy measurement.
