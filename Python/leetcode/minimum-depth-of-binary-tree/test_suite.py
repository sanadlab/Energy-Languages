#!/usr/bin/env python3
"""Bespoke LC loop-harness (new methodology) — object-construction (binary tree).

Usage:  python3 test_suite.py <budget_seconds> <case_index>
  - derives the problem slug from the containing directory name
  - loads the SHARED, language-independent input for that case from
    reference/leetcode/{workloads,outputs}/<slug>.json
  - the input is a level-order serialized tree ({"root":[1,2,3,null,...]});
    this harness BUILDS the TreeNode (the generic harness cannot) and then
    loops solution(root) until <budget> seconds elapse. For mutation safety the
    tree is REBUILT from the serialized list each iteration (a fresh object per
    solve) — the object-construction analogue of the plain-data harness's
    per-iteration copy.deepcopy, and recursion-safe on deep trees where deepcopy
    would blow Python's stack. Each result is folded into a checksum.
Results go to STDERR so stdout stays empty (the cell's `make validate`
empty-stream compare still passes). The driver parses ITERS/BEACON from stderr.
"""
import sys, os, json, time, importlib.util
from collections import deque

CELL = os.path.dirname(os.path.abspath(__file__))
SLUG = os.path.basename(CELL)
REF  = os.path.normpath(os.path.join(CELL, "..", "..", "..", "reference", "leetcode"))


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


def build_tree(values):
    """Standard LC level-order deserializer (None => absent child)."""
    if not values:
        return None
    root = TreeNode(values[0])
    i = 1
    q = deque([root])
    while q:
        node = q.popleft()
        if i < len(values) and values[i] is not None:
            node.left = TreeNode(values[i]); q.append(node.left)
        i += 1
        if i < len(values) and values[i] is not None:
            node.right = TreeNode(values[i]); q.append(node.right)
        i += 1
    return root


def load_case(slug, idx):
    w = json.load(open(os.path.join(REF, "workloads", slug + ".json")))
    ep = (w.get("entry_point") or "").strip()          # e.g. "Solution().minDepth"
    method = ep.split(".")[-1] if ep else "minDepth"
    o = json.load(open(os.path.join(REF, "outputs", slug + ".json")))
    cases = o["expected"]
    c = cases[idx]
    return method, c["name"], c["input"]["root"], len(cases)


def resolve_fn(method):
    spec = importlib.util.spec_from_file_location("solution", os.path.join(CELL, "solution.py"))
    mod = importlib.util.module_from_spec(spec); import typing as _ty; mod.__dict__.update({k: getattr(_ty, k) for k in _ty.__all__}); spec.loader.exec_module(mod)
    target = mod.Solution() if hasattr(mod, "Solution") else mod
    return getattr(target, method)


def fold(acc, r):
    return (acc * 1000003 + (hash(repr(r)) & 0xFFFFFFFF)) & ((1 << 62) - 1)


def main():
    budget = float(sys.argv[1]) if len(sys.argv) > 1 else 1.0
    idx    = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    method, name, root_vals, ncases = load_case(SLUG, idx)
    fn = resolve_fn(method)

    def ser_tree(node):                                 # level-order serialization (mutation probe)
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

    # (1) Build the tree ONCE, solve once, and check whether the solution mutated
    #     it. If not, reuse the same tree each iteration (the per-iteration
    #     rebuild is this cell's mutation-safety clone).
    root = build_tree(root_vals)
    before = ser_tree(root)
    r0 = fn(root)                                       # correctness beacon
    mutated = (ser_tree(root) != before)

    def one():
        return fn(build_tree(root_vals)) if mutated else fn(root)

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
