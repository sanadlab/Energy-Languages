from typing import List


class Solution:
    def maxGeneticDifference(self, parents: List[int], queries: List[List[int]]) -> List[int]:
        n = len(parents)

        children = [[] for _ in range(n)]
        root = 0
        for node, parent in enumerate(parents):
            if parent == -1:
                root = node
            else:
                children[parent].append(node)

        node_queries = [[] for _ in range(n)]
        max_val = n - 1
        for i, (node, val) in enumerate(queries):
            node_queries[node].append((val, i))
            max_val = max(max_val, val)

        max_bit = max_val.bit_length() - 1

        trie0 = [-1]
        trie1 = [-1]
        count = [0]

        def add(num: int, delta: int) -> None:
            cur = 0
            count[cur] += delta

            for bit in range(max_bit, -1, -1):
                if (num >> bit) & 1:
                    nxt = trie1[cur]
                    if nxt == -1:
                        nxt = len(count)
                        trie1[cur] = nxt
                        trie0.append(-1)
                        trie1.append(-1)
                        count.append(0)
                else:
                    nxt = trie0[cur]
                    if nxt == -1:
                        nxt = len(count)
                        trie0[cur] = nxt
                        trie0.append(-1)
                        trie1.append(-1)
                        count.append(0)

                cur = nxt
                count[cur] += delta

        def max_xor(val: int) -> int:
            cur = 0
            res = 0

            for bit in range(max_bit, -1, -1):
                if (val >> bit) & 1:
                    preferred = trie0[cur]
                    if preferred != -1 and count[preferred] > 0:
                        res |= 1 << bit
                        cur = preferred
                    else:
                        cur = trie1[cur]
                else:
                    preferred = trie1[cur]
                    if preferred != -1 and count[preferred] > 0:
                        res |= 1 << bit
                        cur = preferred
                    else:
                        cur = trie0[cur]

            return res

        ans = [0] * len(queries)
        stack = [(root, 0)]

        while stack:
            node, state = stack.pop()

            if state == 0:
                add(node, 1)

                for val, idx in node_queries[node]:
                    ans[idx] = max_xor(val)

                stack.append((node, 1))
                for child in children[node]:
                    stack.append((child, 0))
            else:
                add(node, -1)

        return ans
