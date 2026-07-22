from math import gcd
from collections import defaultdict

class Solution:
    def getCoprimes(self, nums, edges):
        n = len(nums)
        graph = [[] for _ in range(n)]
        for u, v in edges:
            graph[u].append(v)
            graph[v].append(u)

        # Precompute coprime pairs for values 1 to 50
        max_val = 50
        coprime_with = [[] for _ in range(max_val+1)]
        for x in range(1, max_val+1):
            for y in range(1, max_val+1):
                if gcd(x, y) == 1:
                    coprime_with[x].append(y)

        ans = [-1] * n
        # For each value, keep a stack of (node_index, depth)
        # to track the nearest ancestor with that value
        value_stack = defaultdict(list)

        def dfs(u, parent, depth):
            val = nums[u]
            # Find nearest ancestor with coprime value
            nearest_ancestor = -1
            nearest_depth = -1
            for cv in coprime_with[val]:
                if value_stack[cv]:
                    # Check the top of the stack for this value
                    node_idx, node_depth = value_stack[cv][-1]
                    if node_depth > nearest_depth:
                        nearest_depth = node_depth
                        nearest_ancestor = node_idx
            ans[u] = nearest_ancestor

            # Add current node to stack for its value
            value_stack[val].append((u, depth))
            for w in graph[u]:
                if w != parent:
                    dfs(w, u, depth+1)
            # Remove current node from stack before backtracking
            value_stack[val].pop()

        dfs(0, -1, 0)
        return ans
