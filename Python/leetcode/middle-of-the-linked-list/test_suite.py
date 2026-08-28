#!/usr/bin/env python3
"""Bespoke LC loop-harness (new methodology) — middle-of-the-linked-list.

This problem is object-construction: the entry point takes a singly linked
list `head`, so the generic array-passing harness can't build the argument.
This file parses the SHARED serialized input (head = array of ints), builds a
ListNode chain, runs one solve as a correctness beacon, then loops the solve
until <budget> seconds elapse, folding each (serialized) result into a
checksum. Results go to STDERR so stdout stays empty (make validate passes).

Usage:  python3 test_suite.py <budget_seconds> <case_index>
"""
import sys, os, json, time, copy, importlib.util

CELL = os.path.dirname(os.path.abspath(__file__))
SLUG = os.path.basename(CELL)
REF  = os.path.normpath(os.path.join(CELL, "..", "..", "..", "reference", "leetcode"))


class ListNode:
    def __init__(self, val=0, nxt=None):
        self.val = val
        self.next = nxt


def build(arr):
    """Build a singly linked list from a plain array (iterative -> no recursion)."""
    dummy = ListNode()
    cur = dummy
    for v in arr:
        cur.next = ListNode(v)
        cur = cur.next
    return dummy.next


def serialize(node):
    """Serialize a ListNode chain to a plain array (LC standard form)."""
    out = []
    while node is not None:
        out.append(node.val)
        node = node.next
    return out


def load_case(slug, idx):
    w = json.load(open(os.path.join(REF, "workloads", slug + ".json")))
    ep = (w.get("entry_point") or "").strip()          # "Solution().middleNode"
    method = ep.split(".")[-1] if ep else "middleNode"
    o = json.load(open(os.path.join(REF, "outputs", slug + ".json")))
    cases = o["expected"]
    c = cases[idx]
    return method, c["name"], c["input"]["head"], len(cases)


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
    method, name, head_arr, ncases = load_case(SLUG, idx)
    fn = resolve_fn(method)

    # (1) Build the ListNode chain ONCE, solve once, and check via serialize()
    #     whether the solution mutated the list. If not, reuse the same built
    #     node each iteration (the per-iteration rebuild is this cell's clone).
    node = build(copy.deepcopy(head_arr))
    before = serialize(node)
    r0 = serialize(fn(node))                             # correctness beacon
    mutated = (serialize(node) != before)

    def one():
        if mutated:
            return serialize(fn(build(copy.deepcopy(head_arr))))   # rebuild each iter
        return serialize(fn(node))                                 # reuse pristine node

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

    # STDERR only -> stdout empty so `make validate` (empty-stream compare) passes.
    meas = time.perf_counter() - t0
    sys.stderr.write("CASE=%s NCASES=%d ITERS=%d ACC=%d MEAS_S=%.6f BEACON=%s\n"
                     % (name, ncases, iters, acc, meas, repr(r0)[:48]))


main()
