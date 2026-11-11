"""Parity of the LeetCode loop harnesses within a runtime family.

Languages that share a runtime or a toolchain (JavaScript and TypeScript on
Node, C and C++ on GCC, Java/Kotlin/Scala on the JVM, Elixir and Erlang on
BEAM) must measure a solution the same way, so that a later comparison across
languages compares the code and not the harness. Each test runs the real
harnesses through selection/run_harness.sh (build mode, then run mode, as the
runner does) on real problems of reference/leetcode, with equivalent small
solutions, and checks within each family:

* the same result on every call: each harness folds every measured call's
  result hash h into ACC = h * (1 + q + ... + q^(ITERS-1)) mod 2^32 with
  q = 1000003, so h is recovered from (ITERS, ACC) and compared;
* the same policies: a solution that counts calls on its instance, and one
  that changes its input, behave the same in every member (a constant result
  per call, or not);
* a similar per-call floor on a cheap solution.

A family is skipped when one of its tools is missing.
"""
from __future__ import annotations

import os
import re
import shutil
import subprocess
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[2]
LINE = re.compile(r"ITERS=(\d+) ACC=(-?\d+) MEAS_S=([0-9.]+)")
M, Q = 1 << 32, 1000003

# problem -> case index (inputs large enough to do some work)
CASES = {"2-keys-keyboard": 10, "middle-of-the-linked-list": 10,
         "minimum-depth-of-binary-tree": 10,
         "minimum-subsequence-in-non-increasing-order": 10,
         "design-a-stack-with-increment-operation": 10}

JS = {
    "plain": ("2-keys-keyboard", """
var minSteps = function(n) {
  let s = 0;
  for (let d = 2; n > 1; d++) while (n % d === 0) { s += d; n /= d; }
  return s;
};"""),
    "list": ("middle-of-the-linked-list", """
var middleNode = function(head) {
  let s = head, f = head;
  while (f && f.next) { s = s.next; f = f.next.next; }
  return s;
};"""),
    "tree": ("minimum-depth-of-binary-tree", """
var minDepth = function(root) {
  if (!root) return 0;
  let q = [root], d = 1;
  while (q.length) {
    const n = [];
    for (const x of q) {
      if (!x.left && !x.right) return d;
      if (x.left) n.push(x.left);
      if (x.right) n.push(x.right);
    }
    q = n; d++;
  }
  return d;
};"""),
    "sort": ("minimum-subsequence-in-non-increasing-order", """
var minSubsequence = function(nums) {
  nums.sort((a, b) => b - a);
  const total = nums.reduce((a, b) => a + b, 0);
  let s = 0; const out = [];
  for (const x of nums) { s += x; out.push(x); if (s > total - s) break; }
  return out;
};"""),
    "design": ("design-a-stack-with-increment-operation", """
class CustomStack {
  constructor(maxSize) { this.m = maxSize; this.s = []; }
  push(x) { if (this.s.length < this.m) this.s.push(x); }
  pop() { return this.s.length ? this.s.pop() : -1; }
  increment(k, val) { for (let i = 0; i < Math.min(k, this.s.length); i++) this.s[i] += val; }
}"""),
    # policies: the result is constant per call only with a fresh instance per
    # call, and only with a fresh copy of a mutated input per call
    "instance": ("2-keys-keyboard", """
class Solution {
  constructor() { this.calls = 0; }
  minSteps(n) { return ++this.calls; }
}"""),
    "mutation": ("minimum-subsequence-in-non-increasing-order", """
var minSubsequence = function(nums) { nums.reverse(); return [nums[0]]; };"""),
}

JAVA = {
    "plain": """
class Solution {
    public int minSteps(int n) {
        int s = 0;
        for (int d = 2; n > 1; d++) while (n % d == 0) { s += d; n /= d; }
        return s;
    }
}""",
    "list": """
class Solution {
    public ListNode middleNode(ListNode head) {
        ListNode s = head, f = head;
        while (f != null && f.next != null) { s = s.next; f = f.next.next; }
        return s;
    }
}""",
    "tree": """
import java.util.*;
class Solution {
    public int minDepth(TreeNode root) {
        if (root == null) return 0;
        List<TreeNode> q = new ArrayList<>(); q.add(root); int d = 1;
        while (!q.isEmpty()) {
            List<TreeNode> n = new ArrayList<>();
            for (TreeNode x : q) {
                if (x.left == null && x.right == null) return d;
                if (x.left != null) n.add(x.left);
                if (x.right != null) n.add(x.right);
            }
            q = n; d++;
        }
        return d;
    }
}""",
    "sort": """
import java.util.*;
class Solution {
    public List<Integer> minSubsequence(int[] nums) {
        Arrays.sort(nums);
        int total = 0; for (int x : nums) total += x;
        int s = 0; List<Integer> out = new ArrayList<>();
        for (int i = nums.length - 1; i >= 0; i--) { s += nums[i]; out.add(nums[i]); if (s > total - s) break; }
        return out;
    }
}""",
    "design": """
class CustomStack {
    private final int[] st; private int n = 0;
    public CustomStack(int maxSize) { st = new int[maxSize]; }
    public void push(int x) { if (n < st.length) st[n++] = x; }
    public int pop() { return n == 0 ? -1 : st[--n]; }
    public void increment(int k, int val) { for (int i = 0; i < Math.min(k, n); i++) st[i] += val; }
}""",
    "instance": """
class Solution {
    private int calls = 0;
    public int minSteps(int n) { return ++calls; }
}""",
    "mutation": """
import java.util.*;
class Solution {
    public List<Integer> minSubsequence(int[] nums) {
        for (int i = 0, j = nums.length - 1; i < j; i++, j--) { int t = nums[i]; nums[i] = nums[j]; nums[j] = t; }
        return List.of(nums[0]);
    }
}""",
}
KOTLIN = {
    "plain": """
class Solution {
    fun minSteps(n: Int): Int {
        var m = n; var s = 0; var d = 2
        while (m > 1) { while (m % d == 0) { s += d; m /= d }; d++ }
        return s
    }
}""",
    "list": """
class Solution {
    fun middleNode(head: ListNode?): ListNode? {
        var s = head; var f = head
        while (f?.next != null) { s = s?.next; f = f.next?.next }
        return s
    }
}""",
    "tree": """
class Solution {
    fun minDepth(root: TreeNode?): Int {
        if (root == null) return 0
        var q = arrayListOf(root); var d = 1
        while (q.isNotEmpty()) {
            val n = ArrayList<TreeNode>()
            for (x in q) {
                if (x.left == null && x.right == null) return d
                x.left?.let { n.add(it) }
                x.right?.let { n.add(it) }
            }
            q = n; d++
        }
        return d
    }
}""",
    "sort": """
class Solution {
    fun minSubsequence(nums: IntArray): List<Int> {
        nums.sort()
        val total = nums.sum(); var s = 0; val out = ArrayList<Int>()
        for (i in nums.indices.reversed()) { s += nums[i]; out.add(nums[i]); if (s > total - s) break }
        return out
    }
}""",
    "design": """
class CustomStack(maxSize: Int) {
    private val st = IntArray(maxSize); private var n = 0
    fun push(x: Int) { if (n < st.size) st[n++] = x }
    fun pop(): Int = if (n == 0) -1 else st[--n]
    fun increment(k: Int, `val`: Int) { for (i in 0 until minOf(k, n)) st[i] += `val` }
}""",
    "instance": """
class Solution {
    private var calls = 0
    fun minSteps(n: Int): Int = ++calls
}""",
    "mutation": """
class Solution {
    fun minSubsequence(nums: IntArray): List<Int> { nums.reverse(); return listOf(nums[0]) }
}""",
}

CPP = {
    "plain": """
class Solution {
public:
    int minSteps(int n) {
        int s = 0;
        for (int d = 2; n > 1; d++) while (n % d == 0) { s += d; n /= d; }
        return s;
    }
};""",
    "list": """
class Solution {
public:
    ListNode* middleNode(ListNode* head) {
        ListNode *s = head, *f = head;
        while (f && f->next) { s = s->next; f = f->next->next; }
        return s;
    }
};""",
    "tree": """
class Solution {
public:
    int minDepth(TreeNode* root) {
        if (!root) return 0;
        if (!root->left) return 1 + minDepth(root->right);
        if (!root->right) return 1 + minDepth(root->left);
        return 1 + std::min(minDepth(root->left), minDepth(root->right));
    }
};""",
    "sort": """
class Solution {
public:
    vector<int> minSubsequence(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        int total = 0; for (int x : nums) total += x;
        int s = 0; vector<int> out;
        for (int i = (int)nums.size() - 1; i >= 0; i--) { s += nums[i]; out.push_back(nums[i]); if (s > total - s) break; }
        return out;
    }
};""",
    "design": """
class CustomStack {
    vector<int> st; int m;
public:
    CustomStack(int maxSize) : m(maxSize) {}
    void push(int x) { if ((int)st.size() < m) st.push_back(x); }
    int pop() { if (st.empty()) return -1; int x = st.back(); st.pop_back(); return x; }
    void increment(int k, int val) { for (int i = 0; i < std::min(k, (int)st.size()); i++) st[i] += val; }
};""",
    "instance": """
class Solution {
    int calls = 0;
public:
    int minSteps(int n) { return ++calls; }
};""",
    "mutation": """
class Solution {
public:
    vector<int> minSubsequence(vector<int>& nums) { reverse(nums.begin(), nums.end()); return {nums[0]}; }
};""",
}
C = {
    "plain": """
int minSteps(int n) {
    int s = 0;
    for (int d = 2; n > 1; d++) while (n % d == 0) { s += d; n /= d; }
    return s;
}""",
    "list": """
struct ListNode* middleNode(struct ListNode* head) {
    struct ListNode *s = head, *f = head;
    while (f && f->next) { s = s->next; f = f->next->next; }
    return s;
}""",
    "tree": """
int minDepth(struct TreeNode* root) {
    if (!root) return 0;
    if (!root->left) return 1 + minDepth(root->right);
    if (!root->right) return 1 + minDepth(root->left);
    int a = minDepth(root->left), b = minDepth(root->right);
    return 1 + (a < b ? a : b);
}""",
    "sort": """
static int cmp(const void* a, const void* b) { return *(const int*)a - *(const int*)b; }
int* minSubsequence(int* nums, int numsSize, int* returnSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    int total = 0; for (int i = 0; i < numsSize; i++) total += nums[i];
    int* out = malloc(sizeof(int) * numsSize); int k = 0, s = 0;
    for (int i = numsSize - 1; i >= 0; i--) { s += nums[i]; out[k++] = nums[i]; if (s > total - s) break; }
    *returnSize = k;
    return out;
}""",
    "design": """
typedef struct { int* st; int n, m; } CustomStack;
CustomStack* customStackCreate(int maxSize) {
    CustomStack* o = malloc(sizeof(CustomStack)); o->st = malloc(sizeof(int) * maxSize); o->n = 0; o->m = maxSize; return o;
}
void customStackPush(CustomStack* o, int x) { if (o->n < o->m) o->st[o->n++] = x; }
int customStackPop(CustomStack* o) { return o->n == 0 ? -1 : o->st[--o->n]; }
void customStackIncrement(CustomStack* o, int k, int val) { for (int i = 0; i < (k < o->n ? k : o->n); i++) o->st[i] += val; }
void customStackFree(CustomStack* o) { free(o->st); free(o); }""",
    # C has no solution object: a stateless function is its equivalent of the
    # fresh object per call that C++ gets
    "instance": """
int minSteps(int n) { return 1; }""",
    "mutation": """
int* minSubsequence(int* nums, int numsSize, int* returnSize) {
    for (int i = 0, j = numsSize - 1; i < j; i++, j--) { int t = nums[i]; nums[i] = nums[j]; nums[j] = t; }
    int* r = malloc(sizeof(int)); r[0] = nums[0]; *returnSize = 1;
    return r;
}""",
}

SCALA = {
    "plain": """
object Solution {
  def minSteps(n: Int): Int = {
    var m = n; var s = 0; var d = 2
    while (m > 1) { while (m % d == 0) { s += d; m /= d }; d += 1 }
    s
  }
}""",
    "list": """
object Solution {
  def middleNode(head: ListNode): ListNode = {
    var s = head; var f = head
    while (f != null && f.next != null) { s = s.next; f = f.next.next }
    s
  }
}""",
    "tree": """
object Solution {
  def minDepth(root: TreeNode): Int =
    if (root == null) 0
    else if (root.left == null) 1 + minDepth(root.right)
    else if (root.right == null) 1 + minDepth(root.left)
    else 1 + math.min(minDepth(root.left), minDepth(root.right))
}""",
    "sort": """
object Solution {
  def minSubsequence(nums: Array[Int]): List[Int] = {
    java.util.Arrays.sort(nums)
    val total = nums.sum; var s = 0
    val out = scala.collection.mutable.ListBuffer[Int]()
    var i = nums.length - 1; var done = false
    while (i >= 0 && !done) { s += nums(i); out += nums(i); if (s > total - s) done = true; i -= 1 }
    out.toList
  }
}""",
    "design": """
class CustomStack(_maxSize: Int) {
  private val st = new Array[Int](_maxSize); private var n = 0
  def push(x: Int): Unit = { if (n < st.length) { st(n) = x; n += 1 } }
  def pop(): Int = if (n == 0) -1 else { n -= 1; st(n) }
  def increment(k: Int, `val`: Int): Unit = { var i = 0; while (i < math.min(k, n)) { st(i) += `val`; i += 1 } }
}""",
    "instance": """
object Solution {
  private var calls = 0
  def minSteps(n: Int): Int = { calls += 1; calls }
}""",
    "mutation": """
object Solution {
  def minSubsequence(nums: Array[Int]): List[Int] = {
    var i = 0; var j = nums.length - 1
    while (i < j) { val t = nums(i); nums(i) = nums(j); nums(j) = t; i += 1; j -= 1 }
    List(nums(0))
  }
}""",
}

ELIXIR = {
    "plain": """
defmodule Solution do
  def min_steps(n), do: go(n, 2, 0)
  defp go(n, _d, s) when n <= 1, do: s
  defp go(n, d, s) when rem(n, d) == 0, do: go(div(n, d), d, s + d)
  defp go(n, d, s), do: go(n, d + 1, s)
end""",
    "list": """
defmodule Solution do
  def middle_node(head), do: walk(head, head)
  defp walk(s, nil), do: s
  defp walk(s, %ListNode{next: nil}), do: s
  defp walk(s, %ListNode{next: f1}), do: walk(s.next, f1.next)
end""",
    "tree": """
defmodule Solution do
  def min_depth(nil), do: 0
  def min_depth(%TreeNode{left: nil, right: r}), do: 1 + min_depth(r)
  def min_depth(%TreeNode{left: l, right: nil}), do: 1 + min_depth(l)
  def min_depth(%TreeNode{left: l, right: r}), do: 1 + min(min_depth(l), min_depth(r))
end""",
    "sort": """
defmodule Solution do
  def min_subsequence(nums), do: take(Enum.sort(nums, :desc), Enum.sum(nums), 0, [])
  defp take([x | rest], total, s, acc) do
    s2 = s + x
    if s2 > total - s2, do: Enum.reverse([x | acc]), else: take(rest, total, s2, [x | acc])
  end
end""",
    "design": """
defmodule CustomStack do
  def init_(max_size), do: Process.put(:cs, {max_size, []})
  def push(x) do
    {m, st} = Process.get(:cs)
    if length(st) < m, do: Process.put(:cs, {m, st ++ [x]})
    nil
  end
  def pop() do
    case Process.get(:cs) do
      {_m, []} -> -1
      {m, st} -> Process.put(:cs, {m, Enum.drop(st, -1)}); List.last(st)
    end
  end
  def increment(k, val) do
    {m, st} = Process.get(:cs)
    Process.put(:cs, {m, Enum.with_index(st, fn x, i -> if i < k, do: x + val, else: x end)})
    nil
  end
end""",
    # BEAM has no solution object and no mutable input: a stateless function
    # and a non-mutating one are its equivalents
    "instance": """
defmodule Solution do
  def min_steps(_n), do: 1
end""",
    "mutation": """
defmodule Solution do
  def min_subsequence(nums), do: [hd(Enum.reverse(nums))]
end""",
}
ERLANG = {
    "plain": """
-module(solution).
-export([min_steps/1]).
min_steps(N) -> go(N, 2, 0).
go(N, _D, S) when N =< 1 -> S;
go(N, D, S) when N rem D =:= 0 -> go(N div D, D, S + D);
go(N, D, S) -> go(N, D + 1, S).""",
    "list": """
-module(solution).
-export([middle_node/1]).
-include("node.hrl").
middle_node(Head) -> walk(Head, Head).
walk(S, null) -> S;
walk(S, #list_node{next = null}) -> S;
walk(#list_node{next = SN}, #list_node{next = #list_node{next = FN}}) -> walk(SN, FN).""",
    "tree": """
-module(solution).
-export([min_depth/1]).
-include("node.hrl").
min_depth(null) -> 0;
min_depth(#tree_node{left = null, right = R}) -> 1 + min_depth(R);
min_depth(#tree_node{left = L, right = null}) -> 1 + min_depth(L);
min_depth(#tree_node{left = L, right = R}) -> 1 + min(min_depth(L), min_depth(R)).""",
    "sort": """
-module(solution).
-export([min_subsequence/1]).
min_subsequence(Nums) -> take(lists:reverse(lists:sort(Nums)), lists:sum(Nums), 0, []).
take([X | Rest], Total, S, Acc) ->
    S2 = S + X,
    case S2 > Total - S2 of
        true -> lists:reverse([X | Acc]);
        false -> take(Rest, Total, S2, [X | Acc])
    end.""",
    "design": """
-module(solution).
-export([custom_stack_init_/1, custom_stack_push/1, custom_stack_pop/0, custom_stack_increment/2]).
custom_stack_init_(MaxSize) -> put(cs, {MaxSize, []}).
custom_stack_push(X) ->
    {M, St} = get(cs),
    case length(St) < M of true -> put(cs, {M, St ++ [X]}); false -> ok end,
    ok.
custom_stack_pop() ->
    case get(cs) of
        {_M, []} -> -1;
        {M, St} -> put(cs, {M, lists:droplast(St)}), lists:last(St)
    end.
custom_stack_increment(K, Val) ->
    {M, St} = get(cs),
    {New, _} = lists:mapfoldl(fun(X, I) when I < K -> {X + Val, I + 1}; (X, I) -> {X, I + 1} end, 0, St),
    put(cs, {M, New}),
    ok.""",
    "instance": """
-module(solution).
-export([min_steps/1]).
min_steps(_N) -> 1.""",
    "mutation": """
-module(solution).
-export([min_subsequence/1]).
min_subsequence(Nums) -> [hd(lists:reverse(Nums))].""",
}

# family -> {"tools": [...], "langs": {arena_lang: (folder, solution file)},
#            "code": {kind: {arena_lang: source}}, "problems": {kind: slug}}
FAMILIES = {
    "node": {
        "tools": ["node"],
        "langs": {"javascript": ("JavaScript", "solution.js"),
                  "typescript": ("TypeScript", "solution.ts")},
        "code": {k: {"javascript": src, "typescript": src} for k, (_p, src) in JS.items()},
        "problems": {k: p for k, (p, _src) in JS.items()},
    },
    "beam": {
        "tools": ["elixir", "elixirc", "erl", "erlc"],
        "langs": {"elixir": ("Elixir", "solution.ex"), "erlang": ("Erlang", "solution.erl")},
        "code": {k: {"elixir": ELIXIR[k], "erlang": ERLANG[k]} for k in ELIXIR},
        "problems": {k: p for k, (p, _src) in JS.items()},
    },
    "gcc": {
        "tools": ["gcc", "g++", "python3"],
        "langs": {"cpp": ("C++", "solution.cpp"), "c": ("C", "solution.c")},
        "code": {k: {"cpp": CPP[k], "c": C[k]} for k in CPP},
        "problems": {k: p for k, (p, _src) in JS.items()},
    },
    "jvm": {
        "tools": ["java", "javac", "kotlinc", "scalac"],
        "langs": {"java": ("Java", "solution.java"), "kotlin": ("Kotlin", "solution.kt"),
                  "scala": ("Scala", "solution.scala")},
        "code": {k: {"java": JAVA[k], "kotlin": KOTLIN[k], "scala": SCALA[k]} for k in JAVA},
        "problems": {k: p for k, (p, _src) in JS.items()},
    },
}
RESULT_KINDS = ("plain", "list", "tree", "sort", "design")


def _sum_pow(n: int) -> tuple[int, int]:
    """(q^n, 1 + q + ... + q^(n-1)) mod 2^32."""
    if n == 0:
        return 1, 0
    p, s = _sum_pow(n // 2)
    p2, s2 = p * p % M, (s + p * s) % M
    return (p2 * Q % M, (s2 + p2) % M) if n % 2 else (p2, s2)


def _recover(n: int, acc: int) -> tuple[int, int] | None:
    """The per-call hash h (mod 2^bits) from ITERS and ACC, or None."""
    s = _sum_pow(n)[1]
    if s == 0:
        return None
    v = (s & -s).bit_length() - 1
    a = acc % M
    if a % (1 << v):
        return None                     # not a constant per-call result
    bits = 32 - v
    return (a >> v) * pow(s >> v, -1, 1 << bits) % (1 << bits), bits


def _same(x, y) -> bool:
    if x is None or y is None:
        return False
    bits = min(x[1], y[1])
    return x[0] % (1 << bits) == y[0] % (1 << bits)


@pytest.fixture(scope="module")
def tree(tmp_path_factory):
    return tmp_path_factory.mktemp("parity")


def _mini_root(tree: Path, name: str) -> Path:
    """A root like Energy-Languages: copies of the harness files (the C and C++
    generators find their cells relative to their own location) and a link to
    the real reference/."""
    root = tree / name
    if not root.exists():
        sel = root / "selection"
        sel.mkdir(parents=True)
        for f in (ROOT / "selection").iterdir():
            if f.is_file() and f.suffix not in (".json", ".jsonl"):
                shutil.copy(f, sel / f.name)
        (root / "reference").symlink_to(ROOT / "reference")
    return root


def _cell(tree: Path, fam: str, lang: str, kind: str) -> Path:
    """The cell of `lang`, after writing the solutions of every member of the
    family (the C generator reads the C++ cell for the signature)."""
    root = _mini_root(tree, f"{fam}-{kind}")
    slug = FAMILIES[fam]["problems"][kind]
    for member, (folder, fname) in FAMILIES[fam]["langs"].items():
        cell = root / folder / "leetcode" / slug
        cell.mkdir(parents=True, exist_ok=True)
        (cell / fname).write_text(FAMILIES[fam]["code"][kind][member].strip() + "\n")
        real = ROOT / folder / "leetcode" / slug / "problem.json"
        if real.exists() and not (cell / "problem.json").exists():
            shutil.copy(real, cell / "problem.json")
    # the C, C++, and Scala generators take the logical signature from the C++ cell
    cpp_sol = root / "C++" / "leetcode" / slug / "solution.cpp"
    if not cpp_sol.exists():
        cpp_sol.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy(ROOT / "C++" / "leetcode" / slug / "solution.cpp", cpp_sol)
    folder, _fname = FAMILIES[fam]["langs"][lang]
    return root / folder / "leetcode" / slug


_BUILT: set[Path] = set()


def _run(cell: Path, lang: str, budget: float) -> tuple[int, int, float]:
    """Build the cell once (as the runner does before measuring), then run."""
    env = dict(os.environ)
    run_harness = cell.parents[2] / "selection" / "run_harness.sh"
    for mode in (("run",) if cell in _BUILT else ("build", "run")):
        env["PERFARENA_HARNESS_MODE"] = mode
        r = subprocess.run(["bash", str(run_harness), lang, str(budget), str(CASES[cell.name])],
                           cwd=cell, env=env, capture_output=True, text=True, timeout=600)
        assert r.returncode == 0, f"{lang} {mode} failed ({r.returncode}): {r.stderr[-800:]}"
    _BUILT.add(cell)
    m = LINE.search(r.stderr)
    assert m, f"{lang}: no harness line in {r.stderr[-400:]!r}"
    return int(m[1]), int(m[2]), float(m[3])


def _hashes(tree, fam, lang, kind):
    """h recovered from two runs with different budgets (different ITERS)."""
    cell = _cell(tree, fam, lang, kind)
    out = []
    for budget in (0.02, 0.06):
        n, acc, _ = _run(cell, lang, budget)
        out.append(_recover(n, acc))
    return out


def _skip_missing(fam):
    missing = [t for t in FAMILIES[fam]["tools"] if shutil.which(t) is None]
    if missing:
        pytest.skip(f"{fam}: missing {missing}")


@pytest.mark.parametrize("fam", sorted(FAMILIES))
@pytest.mark.parametrize("kind", RESULT_KINDS)
def test_same_result_on_every_call(tree, fam, kind):
    _skip_missing(fam)
    got = {lang: _hashes(tree, fam, lang, kind) for lang in FAMILIES[fam]["langs"]}
    for lang, (a, b) in got.items():
        assert _same(a, b), f"{lang}: the per-call result is not constant"
    first, *rest = got.values()
    for lang, h in zip(list(got)[1:], rest):
        assert _same(first[0], h[0]), f"{fam}/{kind}: {lang} folds another result"


@pytest.mark.parametrize("fam", sorted(FAMILIES))
@pytest.mark.parametrize("kind", ("instance", "mutation"))
def test_same_policies(tree, fam, kind):
    _skip_missing(fam)
    constant = {}
    for lang in FAMILIES[fam]["langs"]:
        a, b = _hashes(tree, fam, lang, kind)
        constant[lang] = _same(a, b)
    assert len(set(constant.values())) == 1, f"{fam}/{kind}: {constant}"


@pytest.mark.parametrize("fam", sorted(FAMILIES))
def test_similar_per_call_floor(tree, fam):
    _skip_missing(fam)
    per_call = {}
    for lang in FAMILIES[fam]["langs"]:
        cell = _cell(tree, fam, lang, "plain")
        n, _acc, meas = _run(cell, lang, 0.3)
        per_call[lang] = meas / n
    lo, hi = min(per_call.values()), max(per_call.values())
    assert hi / lo < 2.0, f"{fam}: per-call seconds {per_call}"


def test_jvm_copies_a_changed_char_grid(tree):
    """The Java/Kotlin harness must see a change to a char[][] input and give
    each call a fresh copy (before the fix, canon() hashed a char[] by identity)."""
    for t in FAMILIES["jvm"]["tools"]:
        if shutil.which(t) is None:
            pytest.skip(f"missing {t}")
    slug = "maximum-students-taking-exam"
    cell = _mini_root(tree, "jvm-chars") / "Java" / "leetcode" / slug
    cell.mkdir(parents=True, exist_ok=True)
    (cell / "solution.java").write_text("""
class Solution {
    public int maxStudents(char[][] seats) {
        seats[0][0] = seats[0][0] == '#' ? '.' : '#';
        return seats[0][0];
    }
}
""")
    CASES.setdefault(slug, 10)
    a = _recover(*_run(cell, "java", 0.02)[:2])
    b = _recover(*_run(cell, "java", 0.06)[:2])
    assert _same(a, b), "the char grid was not copied: the per-call result changes"
