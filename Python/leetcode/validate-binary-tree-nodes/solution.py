from typing import List

class Solution:
    def validateBinaryTreeNodes(self, n: int, leftChild: List[int], rightChild: List[int]) -> bool:
        m = min(len(leftChild), len(rightChild))
        indeg = [0] * n
        for i in range(m):
            for c in (leftChild[i], rightChild[i]):
                if c != -1:
                    if c < 0 or c >= n:
                        return False
                    indeg[c] += 1
                    if indeg[c] > 1:
                        return False
        root = -1
        for i in range(n):
            if indeg[i] == 0:
                if root != -1:
                    return False
                root = i
        if root == -1:
            return False
        visited = [False] * n
        stack = [root]
        count = 0
        while stack:
            node = stack.pop()
            if visited[node]:
                return False
            visited[node] = True
            count += 1
            if node < m:
                for c in (leftChild[node], rightChild[node]):
                    if c != -1:
                        stack.append(c)
        return count == n
