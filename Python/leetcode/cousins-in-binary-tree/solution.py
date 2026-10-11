from collections import deque
from typing import Optional

# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right

class Solution:
    def isCousins(self, root: Optional[TreeNode], x: int, y: int) -> bool:
        if root is None:
            return False

        queue = deque([(root, None)])

        while queue:
            parents = []

            for _ in range(len(queue)):
                node, parent = queue.popleft()

                if node.val == x or node.val == y:
                    parents.append(parent)

                if node.left:
                    queue.append((node.left, node))
                if node.right:
                    queue.append((node.right, node))

            if parents:
                return len(parents) == 2 and parents[0] is not parents[1]

        return False