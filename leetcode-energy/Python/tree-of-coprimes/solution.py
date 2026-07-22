from typing import List
from math import gcd

class Solution:
    def getCoprimes(self, nums: List[int], edges: List[List[int]]) -> List[int]:
        n = len(nums)
        
        graph = [[] for _ in range(n)]
        for u, v in edges:
            graph[u].append(v)
            graph[v].append(u)
        
        coprime = [[] for _ in range(51)]
        for i in range(1, 51):
            for j in range(1, 51):
                if gcd(i, j) == 1:
                    coprime[i].append(j)
        
        ans = [-1] * n
        path = [[] for _ in range(51)]
        
        stack = [(0, -1, 0, 0)]
        
        while stack:
            node, parent, depth, state = stack.pop()
            val = nums[node]
            
            if state == 0:
                best_depth = -1
                best_node = -1
                
                for x in coprime[val]:
                    if path[x] and path[x][-1][0] > best_depth:
                        best_depth, best_node = path[x][-1]
                
                ans[node] = best_node
                
                path[val].append((depth, node))
                
                stack.append((node, parent, depth, 1))
                for nei in graph[node]:
                    if nei != parent:
                        stack.append((nei, node, depth + 1, 0))
            else:
                path[val].pop()
        
        return ans
