import java.util.*;

class Solution {
    public int[] getCoprimes(int[] nums, int[][] edges) {
        int n = nums.length;
        int[] ans = new int[n];
        Arrays.fill(ans, -1);

        List<List<Integer>> adj = new ArrayList<>();
        for (int i = 0; i < n; i++) adj.add(new ArrayList<>());
        for (int[] e : edges) {
            if (e.length < 2) continue;
            int u = e[0], v = e[1];
            if (u >= 0 && u < n && v >= 0 && v < n) {
                adj.get(u).add(v);
                adj.get(v).add(u);
            }
        }

        List<List<Integer>> coprime = new ArrayList<>();
        for (int i = 0; i <= 50; i++) coprime.add(new ArrayList<>());
        for (int a = 1; a <= 50; a++)
            for (int b = 1; b <= 50; b++)
                if (gcd(a, b) == 1) coprime.get(a).add(b);

        @SuppressWarnings("unchecked")
        Deque<int[]>[] stacks = new ArrayDeque[51];
        for (int i = 0; i <= 50; i++) stacks[i] = new ArrayDeque<>();

        if (n == 0) return ans;
        dfs(0, -1, 0, nums, adj, coprime, stacks, ans);
        return ans;
    }

    private void dfs(int node, int parent, int depth, int[] nums,
                     List<List<Integer>> adj, List<List<Integer>> coprime,
                     Deque<int[]>[] stacks, int[] ans) {
        int val = nums[node];
        int bestDepth = -1, bestNode = -1;
        for (int cv : coprime.get(val)) {
            int[] top = stacks[cv].peek();
            if (top != null && top[0] > bestDepth) {
                bestDepth = top[0];
                bestNode = top[1];
            }
        }
        ans[node] = bestNode;
        stacks[val].push(new int[]{depth, node});
        for (int nb : adj.get(node)) {
            if (nb != parent) dfs(nb, node, depth + 1, nums, adj, coprime, stacks, ans);
        }
        stacks[val].pop();
    }

    private int gcd(int a, int b) {
        while (b != 0) {
            int t = b;
            b = a % b;
            a = t;
        }
        return a;
    }
}
