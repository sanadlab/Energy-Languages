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
    if (root === null) return false;

    const queue: [TreeNode, TreeNode | null][] = [[root, null]];
    let head = 0;

    while (head < queue.length) {
        const levelEnd = queue.length;
        let foundX = false;
        let foundY = false;
        let parentX: TreeNode | null = null;
        let parentY: TreeNode | null = null;

        while (head < levelEnd) {
            const [node, parent] = queue[head++];

            if (node.val === x) {
                foundX = true;
                parentX = parent;
            }
            if (node.val === y) {
                foundY = true;
                parentY = parent;
            }

            if (node.left !== null) queue.push([node.left, node]);
            if (node.right !== null) queue.push([node.right, node]);
        }

        if (foundX || foundY) {
            return foundX && foundY && parentX !== parentY;
        }
    }

    return false;
};// LC-energy test suite (TypeScript) — cousins-in-binary-tree.
// Concatenated after solution.ts by the Makefile.
class TreeNode {
    val: number; left: TreeNode | null; right: TreeNode | null;
    constructor(val?: number, left?: TreeNode | null, right?: TreeNode | null) {
        this.val = val ?? 0;
        this.left = left ?? null;
        this.right = right ?? null;
    }
}
const _lc_root = new TreeNode(1,
    new TreeNode(2, null, new TreeNode(4)),
    new TreeNode(3, null, new TreeNode(5))
);
const _lc_r = isCousins(_lc_root, 4, 5);
if (!_lc_r) console.log("unexpected");
