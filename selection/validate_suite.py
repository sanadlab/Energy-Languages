#!/usr/bin/env python3
"""Full-suite correctness validator (Python).

Runs the cell's solution.py against EVERY reference case for the problem and
compares each result to the expected output. Unlike the old `make validate`
(which for LeetCode cells diffs stdout against /dev/null and so checks nothing),
this is a real correctness oracle: PASS only if every case matches.

Run FROM the cell dir (Energy-Languages/Python/leetcode/<slug>/):
    python3 ../../../selection/validate_suite.py

Reads the shared, language-independent cases from
reference/leetcode/{workloads,outputs}/<slug>.json — the same source the
measurement harness uses, so correctness and performance judge identical inputs.

Prints ONE line to stderr and exits:
    VALIDATE slug=<slug> PASS ncases=N                 -> exit 0  (Accepted)
    VALIDATE slug=<slug> FAIL case=<name> ...          -> exit 1  (Wrong Answer)
    VALIDATE slug=<slug> RE case=<name> ...            -> exit 3  (Runtime Error)
    VALIDATE slug=<slug> ERROR ...                     -> exit 2  (load/setup)
"""
import sys, os, json, copy, importlib.util
from collections import deque

sys.setrecursionlimit(1_000_000)  # match the measurement harness / LeetCode (deep recursive trees)

CELL = os.getcwd()
SLUG = os.path.basename(CELL)
REF = os.path.normpath(os.path.join(CELL, "..", "..", "..", "reference", "leetcode"))

# Problems where LeetCode accepts the answer in ANY order (special judge):
# compare as a multiset so a correct permutation is not a false Wrong Answer.
_UNORDERED = {"uncommon-words-from-two-sentences", "remove-invalid-parentheses",
              "restore-the-array-from-adjacent-pairs"}


# Node types LeetCode injects for tree/list problems (the solution references
# `TreeNode`/`ListNode` without defining them). Built from the shared level-order
# / array serialization; a node RESULT is canonicalised back the same way.
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val; self.left = left; self.right = right


class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val; self.next = next


def build_tree(vals):
    if not vals or vals[0] is None:
        return None
    root = TreeNode(vals[0]); q = deque([root]); i = 1
    while q and i < len(vals):
        n = q.popleft()
        if i < len(vals) and vals[i] is not None:
            n.left = TreeNode(vals[i]); q.append(n.left)
        i += 1
        if i < len(vals) and vals[i] is not None:
            n.right = TreeNode(vals[i]); q.append(n.right)
        i += 1
    return root


def build_list(vals):
    if not vals:
        return None
    head = ListNode(vals[0]); cur = head
    for v in vals[1:]:
        cur.next = ListNode(v); cur = cur.next
    return head


def _load():
    w = json.load(open(os.path.join(REF, "workloads", SLUG + ".json")))
    ep = (w.get("entry_point") or "").strip()
    method = ep.split(".")[-1].replace("()", "") if ep else None
    o = json.load(open(os.path.join(REF, "outputs", SLUG + ".json")))
    return method, o["expected"]


def _load_solution():
    spec = importlib.util.spec_from_file_location(
        "solution", os.path.join(CELL, "solution.py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    # Provide TreeNode/ListNode the way LeetCode's judge does, unless the cell
    # ships its own. Attribute access is duck-typed, so canon works either way.
    if not hasattr(mod, "TreeNode"):
        mod.TreeNode = TreeNode
    if not hasattr(mod, "ListNode"):
        mod.ListNode = ListNode
    return mod


def _norm(v):
    """Normalise for comparison: TreeNode/ListNode -> array shape, tuples -> lists
    (JSON has no tuples), recurse. Nodes are detected duck-typed so a solution's
    own TreeNode/ListNode class canonicalises the same way."""
    if v is None:
        return None
    if hasattr(v, "val") and hasattr(v, "next"):            # ListNode
        out = []
        while v is not None:
            out.append(v.val); v = v.next
        return out
    if hasattr(v, "val") and (hasattr(v, "left") or hasattr(v, "right")):  # TreeNode
        out = []; q = deque([v])
        while q:
            n = q.popleft()
            if n is None:
                out.append(None); continue
            out.append(n.val); q.append(n.left); q.append(n.right)
        while out and out[-1] is None:
            out.pop()
        return out
    if isinstance(v, (tuple, list)):
        return [_norm(x) for x in v]
    return v


def _run_case(mod, method, case):
    """Execute one case, returning the actual result in the SAME shape as the
    stored expected output. Handles call-mode, design/trace-mode, and the
    randomized `random-pick-index` (validity: nums[pick] must equal target)."""
    inp = case["input"]
    # ---- design / trace mode: ops[0] is the class, the rest are method calls
    if isinstance(inp, dict) and "ops" in inp and "args" in inp:
        ops, args = inp["ops"], inp["args"]
        cls = getattr(mod, ops[0], None)
        if cls is None:
            # The trace's class name differs from what solution.py defines —
            # fall back to the single class the module exposes.
            classes = [v for v in vars(mod).values() if isinstance(v, type)
                       and v.__module__ == mod.__name__]
            cls = classes[0] if len(classes) == 1 else None
        if cls is None:
            raise RuntimeError(f"no class {ops[0]!r} in solution.py")
        randomized = (SLUG == "random-pick-index")
        nums = args[0][0] if randomized and args and args[0] else None
        obj, out = None, []
        for op, a in zip(ops, args):
            aa = copy.deepcopy(a)
            if obj is None:                       # first entry = constructor
                obj = cls(*aa)
                out.append(None)
            else:
                r = getattr(obj, op)(*aa)
                # random-pick returns a random valid index; the reference output
                # stores nums[index] (== target for any correct solution), so
                # canonicalise the same way instead of comparing raw indices.
                if randomized and op == "pick" and isinstance(r, int) and nums is not None:
                    r = nums[r]
                out.append(r)
        return _norm(out)
    # ---- call mode: input is {argname: value}; root/head build tree/list nodes
    target = mod.Solution() if hasattr(mod, "Solution") else mod
    fn = getattr(target, method)
    fargs = []
    for k, v in inp.items():
        if k == "root":
            fargs.append(build_tree(v))
        elif k == "head":
            fargs.append(build_list(v))
        else:
            fargs.append(copy.deepcopy(v))
    return _norm(fn(*fargs))


def _seq_ok(actual, expected):
    """design/trace: a null in expected marks a void op (LeetCode discards its
    return); compare strictly only at value-returning positions."""
    if not isinstance(actual, list) or not isinstance(expected, list) or len(actual) != len(expected):
        return False
    return all(e is None or _norm(a) == _norm(e) for a, e in zip(actual, expected))


def _unordered_eq(actual, expected):
    if not isinstance(actual, list) or not isinstance(expected, list):
        return actual == expected
    key = lambda xs: sorted(json.dumps(x, sort_keys=True) for x in xs)
    return key(actual) == key(expected)


def main():
    try:
        method, cases = _load()
        mod = _load_solution()
    except Exception as e:  # noqa: BLE001
        sys.stderr.write(f"VALIDATE slug={SLUG} ERROR load: {e}\n")
        sys.exit(2)

    for c in cases:
        name = c.get("name")
        try:
            actual = _run_case(mod, method, c)
        except Exception as e:  # noqa: BLE001
            sys.stderr.write(
                f"VALIDATE slug={SLUG} RE case={name} {type(e).__name__}: {e}\n")
            sys.exit(3)
        expected = _norm(c["output"])
        inp = c["input"]
        is_design = isinstance(inp, dict) and "ops" in inp and "args" in inp
        if is_design:
            ok = _seq_ok(actual, expected)
        elif SLUG in _UNORDERED:
            ok = _unordered_eq(actual, expected)
        else:
            ok = (actual == expected)
        if not ok:
            sys.stderr.write(
                f"VALIDATE slug={SLUG} FAIL case={name} "
                f"expected={json.dumps(expected)[:120]} "
                f"actual={json.dumps(actual, default=str)[:120]}\n")
            sys.exit(1)

    sys.stderr.write(f"VALIDATE slug={SLUG} PASS ncases={len(cases)}\n")
    sys.exit(0)


if __name__ == "__main__":
    main()
