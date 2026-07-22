# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def isCousins(self, root: TreeNode, x: int, y: int) -> bool:
        # We will do a BFS traversal to find the depth and parent of x and y
        from collections import deque
        
        queue = deque([(root, None, 0)])  # node, parent, depth
        x_info = y_info = None
        
        while queue:
            node, parent, depth = queue.popleft()
            if node.val == x:
                x_info = (parent, depth)
            if node.val == y:
                y_info = (parent, depth)
            if node.left:
                queue.append((node.left, node, depth + 1))
            if node.right:
                queue.append((node.right, node, depth + 1))
            if x_info and y_info:
                break
        
        # Check if depths are the same and parents are different
        return x_info[1] == y_info[1] and x_info[0] != y_info[0]
