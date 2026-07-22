from typing import List

class Solution:
    def validateBinaryTreeNodes(self, n: int, leftChild: List[int], rightChild: List[int]) -> bool:
        indegree = [0] * n
        
        for i in range(n):
            for child in (leftChild[i], rightChild[i]):
                if child != -1:
                    indegree[child] += 1
                    if indegree[child] > 1:
                        return False
        
        roots = [i for i in range(n) if indegree[i] == 0]
        if len(roots) != 1:
            return False
        
        root = roots[0]
        visited = [False] * n
        visited[root] = True
        stack = [root]
        count = 0
        
        while stack:
            node = stack.pop()
            count += 1
            
            for child in (leftChild[node], rightChild[node]):
                if child != -1:
                    if visited[child]:
                        return False
                    visited[child] = True
                    stack.append(child)
        
        return count == n
