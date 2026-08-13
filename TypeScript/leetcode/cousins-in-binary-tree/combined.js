"use strict";
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
function isCousins(root, x, y) {
    if (!root)
        return false;
    // We will store [parent, depth] for x and y
    let xInfo = null;
    let yInfo = null;
    function dfs(node, parent, depth) {
        if (!node)
            return;
        if (node.val === x)
            xInfo = [parent, depth];
        if (node.val === y)
            yInfo = [parent, depth];
        if (xInfo && yInfo)
            return; // both found, no need to continue
        dfs(node.left, node, depth + 1);
        dfs(node.right, node, depth + 1);
    }
    dfs(root, null, 0);
    if (!xInfo || !yInfo)
        return false;
    // Cousins if same depth but different parents
    return xInfo[1] === yInfo[1] && xInfo[0] !== yInfo[0];
} // LC-energy test suite (TypeScript) — cousins-in-binary-tree.
// Concatenated after solution.ts by the Makefile.
class TreeNode {
    constructor(val, left, right) {
        this.val = val ?? 0;
        this.left = left ?? null;
        this.right = right ?? null;
    }
}
const _lc_root = new TreeNode(1, new TreeNode(2, null, new TreeNode(4)), new TreeNode(3, null, new TreeNode(5)));
const _lc_r = isCousins(_lc_root, 4, 5);
if (!_lc_r)
    console.log("unexpected");
