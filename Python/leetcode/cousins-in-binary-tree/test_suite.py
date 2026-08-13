#!/usr/bin/env python3
"""LC loop-harness (new methodology) — cousins-in-binary-tree (tree input).

Usage:  python3 test_suite.py <budget_seconds> <case_index>
  - derives the slug from the containing directory name
  - loads the SHARED, language-independent input for that case from
    reference/leetcode/{workloads,outputs}/<slug>.json
  - the input is stored in standard LeetCode serialized form
    ({"root":[level-order list with nulls], "x":int, "y":int}); this bespoke
    harness deserializes `root` into a TreeNode, then loops the solve until
    <budget> seconds elapse, deepcopy-ing the tree each iteration for mutation
    safety and folding each result into a checksum.
  - results go to STDERR so stdout stays empty (`make validate` passes).
"""
import sys, os, json, time, copy, importlib.util
from collections import deque

sys.setrecursionlimit(1_000_000)

CELL = os.path.dirname(os.path.abspath(__file__))
SLUG = os.path.basename(CELL)
REF  = os.path.normpath(os.path.join(CELL, "..", "..", "..", "reference", "leetcode"))


def build_tree(vals):
    """LC level-order list (with None) -> TreeNode root."""
    if not vals:
        return None
    root = TreeNode(vals[0])
    q = deque([root])
    i = 1
    while q and i < len(vals):
        n = q.popleft()
        if i < len(vals) and vals[i] is not None:
            n.left = TreeNode(vals[i]); q.append(n.left)
        i += 1
        if i < len(vals) and vals[i] is not None:
            n.right = TreeNode(vals[i]); q.append(n.right)
        i += 1
    return root


def load_case(slug, idx):
    w = json.load(open(os.path.join(REF, "workloads", slug + ".json")))
    ep = (w.get("entry_point") or "").strip()      # e.g. "Solution().isCousins"
    method = ep.split(".")[-1] if ep else "isCousins"
    o = json.load(open(os.path.join(REF, "outputs", slug + ".json")))
    cases = o["expected"]
    c = cases[idx]
    return method, c["name"], c["input"], len(cases)


def load_solution():
    spec = importlib.util.spec_from_file_location("solution", os.path.join(CELL, "solution.py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def fold(acc, r):
    return (acc * 1000003 + (hash(repr(r)) & 0xFFFFFFFF)) & ((1 << 62) - 1)


def main():
    budget = float(sys.argv[1]) if len(sys.argv) > 1 else 1.0
    idx    = int(sys.argv[2]) if len(sys.argv) > 2 else 0

    global TreeNode
    mod = load_solution()
    TreeNode = mod.TreeNode
    method, name, inp, ncases = load_case(SLUG, idx)
    fn = getattr(mod.Solution(), method)

    root_template = build_tree(inp["root"])       # built once
    x, y = inp["x"], inp["y"]

    def ser_tree(node):                           # level-order serialization (mutation probe)
        out = []
        q = deque([node])
        while q:
            n = q.popleft()
            if n is None:
                out.append(None)
            else:
                out.append(n.val)
                q.append(n.left); q.append(n.right)
        return out

    # (1) Detect once whether the solution mutates the tree. If it does not, pass
    #     root_template directly each iteration instead of deep-copying it (the
    #     per-iteration deepcopy dominated this cheap solve).
    before = ser_tree(root_template)
    r0 = fn(root_template, x, y)                   # correctness beacon
    mutated = (ser_tree(root_template) != before)
    if mutated:
        root_template = build_tree(inp["root"])   # restore pristine tree

    def one():
        return fn(copy.deepcopy(root_template), x, y) if mutated else fn(root_template, x, y)

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
