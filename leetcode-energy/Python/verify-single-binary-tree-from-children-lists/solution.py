from typing import List

class Solution:
    def validateBinaryTreeNodes(self, n: int, leftChild: List[int], rightChild: List[int]) -> bool:
        # Each node except the root has exactly one parent.
        # So count parents for each node.
        parent_count = [0] * n
        
        for i in range(n):
            if leftChild[i] != -1:
                parent_count[leftChild[i]] += 1
                if parent_count[leftChild[i]] > 1:
                    return False
            if rightChild[i] != -1:
                parent_count[rightChild[i]] += 1
                if parent_count[rightChild[i]] > 1:
                    return False
        
        # Find the root (node with no parent)
        roots = [i for i, p in enumerate(parent_count) if p == 0]
        if len(roots) != 1:
            return False
        root = roots[0]
        
        # Check if all nodes are reachable from root (no disconnected components)
        visited = set()
        stack = [root]
        while stack:
            node = stack.pop()
            if node in visited:
                # Cycle detected
                return False
            visited.add(node)
            if leftChild[node] != -1:
                stack.append(leftChild[node])
            if rightChild[node] != -1:
                stack.append(rightChild[node])
        
        # All nodes must be visited exactly once
        return len(visited) == n
