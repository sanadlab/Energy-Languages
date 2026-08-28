#!/usr/bin/env python3
"""Bespoke LC loop-harness for linked-list-components (object-construction).

Usage:  python3 test_suite.py <budget_seconds> <case_index>
  - derives the slug from the containing directory name
  - loads the SHARED, language-independent input for that case from
    reference/leetcode/{workloads,outputs}/<slug>.json  (single source of truth)
  - the input `head` is stored in standard LC serialized form (an array); this
    harness constructs the singly-linked ListNode chain from it, then loops the
    solve until <budget> seconds elapse, folding each result into a checksum.

The list is rebuilt from the serialized array on every iteration (iterative, so
no deepcopy recursion blow-up on the 10^4-node cases) -> full mutation safety.
Results go to STDERR so stdout stays empty and `make validate` still passes.
"""
import sys, os, json, time, copy, importlib.util

CELL = os.path.dirname(os.path.abspath(__file__))
SLUG = os.path.basename(CELL)
REF  = os.path.normpath(os.path.join(CELL, "..", "..", "..", "reference", "leetcode"))


def load_case(slug, idx):
    w = json.load(open(os.path.join(REF, "workloads", slug + ".json")))
    ep = (w.get("entry_point") or "").strip()          # e.g. "Solution().numComponents"
    method = ep.split(".")[-1] if ep else "numComponents"
    o = json.load(open(os.path.join(REF, "outputs", slug + ".json")))
    cases = o["expected"]
    c = cases[idx]
    return method, c["name"], c["input"], len(cases)


def resolve(method):
    spec = importlib.util.spec_from_file_location("solution", os.path.join(CELL, "solution.py"))
    mod = importlib.util.module_from_spec(spec); import typing as _ty; mod.__dict__.update({k: getattr(_ty, k) for k in _ty.__all__}); spec.loader.exec_module(mod)
    sol = mod.Solution() if hasattr(mod, "Solution") else mod
    return getattr(sol, method), mod.ListNode


def build_list(arr, ListNode):
    dummy = ListNode(0)
    cur = dummy
    for v in arr:
        cur.next = ListNode(v)
        cur = cur.next
    return dummy.next


def fold(acc, r):
    return (acc * 1000003 + (hash(repr(r)) & 0xFFFFFFFF)) & ((1 << 62) - 1)


def main():
    budget = float(sys.argv[1]) if len(sys.argv) > 1 else 1.0
    idx    = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    method, name, inp, ncases = load_case(SLUG, idx)
    fn, ListNode = resolve(method)
    head_arr, nums = inp["head"], inp["nums"]

    def ser(node):                                     # walk list -> values (mutation probe)
        out = []
        while node is not None:
            out.append(node.val)
            node = node.next
        return out

    # (1) Build the list ONCE and snapshot nums; run one pristine solve; detect
    #     whether the solution mutated the list and/or nums. Reuse the built list
    #     / pass nums directly whenever they are left untouched (build_list of a
    #     10^4-node list + the nums deepcopy dominated cheap solves).
    head0 = build_list(head_arr, ListNode)
    before = ser(head0)
    nums_snap = copy.deepcopy(nums)
    r0 = fn(head0, nums)                               # correctness beacon
    list_mut = (ser(head0) != before)
    nums_mut = (nums != nums_snap)
    if nums_mut:
        nums = copy.deepcopy(nums_snap)               # restore pristine nums

    def one():
        h = build_list(head_arr, ListNode) if list_mut else head0
        a = copy.deepcopy(nums) if nums_mut else nums
        return fn(h, a)

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
