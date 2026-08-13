from typing import List
from collections import defaultdict


class Solution:
    def restoreArray(self, adjacentPairs: List[List[int]]) -> List[int]:
        adj = defaultdict(list)
        for u, v in adjacentPairs:
            adj[u].append(v)
            adj[v].append(u)
        n = len(adjacentPairs) + 1
        start = adjacentPairs[0][0] if adjacentPairs else 0
        for node, nbrs in adj.items():
            if len(nbrs) == 1:
                start = node
                break
        res = [start]
        prev = start
        cur = start
        has_prev = False
        while len(res) < n:
            nxt = None
            for x in adj[cur]:
                if not has_prev or x != prev:
                    nxt = x
                    break
            if nxt is None:
                break
            res.append(nxt)
            prev = cur
            has_prev = True
            cur = nxt
        return res
