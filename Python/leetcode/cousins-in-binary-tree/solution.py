class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def isCousins(self, root, x, y):
        info = {}

        def dfs(node, parent, depth):
            if not node:
                return
            if node.val == x:
                info['x'] = (depth, parent)
            if node.val == y:
                info['y'] = (depth, parent)
            dfs(node.left, node, depth + 1)
            dfs(node.right, node, depth + 1)

        dfs(root, None, 0)
        return info['x'][0] == info['y'][0] and info['x'][1] is not info['y'][1]
