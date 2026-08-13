/**
 * Definition for a binary tree node.
 * class TreeNode {
 *     val: number
 *     left: TreeNode | null
 *     right: TreeNode | null
 *     constructor(val?: number, left?: TreeNode | null, right?: TreeNode | null) {
 *         this.val = (val===undefined ? 0 : val)
 *         this.left = (left===undefined ? null : left)
 *         this.right = (right===undefined ? null : right)
 *     }
 * }
 */

function isCousins(root: TreeNode | null, x: number, y: number): boolean {
    if (!root) return false;

    // We will store [parent, depth] for x and y
    let xInfo: [TreeNode | null, number] | null = null;
    let yInfo: [TreeNode | null, number] | null = null;

    function dfs(node: TreeNode | null, parent: TreeNode | null, depth: number) {
        if (!node) return;
        if (node.val === x) xInfo = [parent, depth];
        if (node.val === y) yInfo = [parent, depth];
        if (xInfo && yInfo) return; // both found, no need to continue
        dfs(node.left, node, depth + 1);
        dfs(node.right, node, depth + 1);
    }

    dfs(root, null, 0);

    if (!xInfo || !yInfo) return false;

    // Cousins if same depth but different parents
    return xInfo[1] === yInfo[1] && xInfo[0] !== yInfo[0];
}