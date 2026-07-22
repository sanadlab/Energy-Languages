from typing import List, Optional

class Solution:
    def canMerge(self, trees: List[TreeNode]) -> Optional[TreeNode]:
        roots = {tree.val: tree for tree in trees}
        leaf_values = set()

        for tree in trees:
            if tree.left:
                leaf_values.add(tree.left.val)
            if tree.right:
                leaf_values.add(tree.right.val)

        candidates = [tree for tree in trees if tree.val not in leaf_values]
        if len(candidates) != 1:
            return None

        root = candidates[0]
        roots.pop(root.val)

        stack = [(root, float("-inf"), float("inf"))]

        while stack:
            node, low, high = stack.pop()

            if not (low < node.val < high):
                return None

            if node.left is None and node.right is None and node.val in roots:
                merge_root = roots.pop(node.val)
                node.left = merge_root.left
                node.right = merge_root.right

            if node.right:
                stack.append((node.right, node.val, high))
            if node.left:
                stack.append((node.left, low, node.val))

        return root if not roots else None
