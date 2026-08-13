from math import gcd


class Solution:
    def getCoprimes(self, nums, edges):
        n = len(nums)
        ans = [-1] * n
        adj = [[] for _ in range(n)]
        for e in (edges or []):
            if not isinstance(e, (list, tuple)) or len(e) < 2:
                continue
            u, v = e[0], e[1]
            if isinstance(u, int) and isinstance(v, int) and 0 <= u < n and 0 <= v < n:
                adj[u].append(v)
                adj[v].append(u)

        # Precompute, for each value 1..50, the values coprime with it.
        coprime = [[] for _ in range(51)]
        for a in range(1, 51):
            for b in range(1, 51):
                if gcd(a, b) == 1:
                    coprime[a].append(b)

        # Ancestor stacks indexed by VALUE (size 51); answer indexed by NODE (size n).
        depth_stack = [[] for _ in range(51)]
        node_stack = [[] for _ in range(51)]
        if n == 0:
            return ans

        # Iterative DFS with enter/exit markers to keep ancestor stacks correct
        # and avoid Python recursion-depth limits on deep trees.
        stack = [(0, -1, 0, False)]
        while stack:
            node, parent, depth, processed = stack.pop()
            val = nums[node]
            if processed:
                depth_stack[val].pop()
                node_stack[val].pop()
                continue
            best_depth = -1
            best_node = -1
            for cv in coprime[val]:
                ds = depth_stack[cv]
                if ds and ds[-1] > best_depth:
                    best_depth = ds[-1]
                    best_node = node_stack[cv][-1]
            ans[node] = best_node
            stack.append((node, parent, depth, True))
            depth_stack[val].append(depth)
            node_stack[val].append(node)
            for nb in adj[node]:
                if nb != parent:
                    stack.append((nb, node, depth + 1, False))
        return ans
