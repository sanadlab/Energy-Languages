"use strict";
function minDepth(root) {
    if (root === null)
        return 0;
    let queue = [root];
    let depth = 1;
    while (queue.length) {
        const next = [];
        for (const node of queue) {
            if (node.left === null && node.right === null)
                return depth;
            if (node.left !== null)
                next.push(node.left);
            if (node.right !== null)
                next.push(node.right);
        }
        queue = next;
        depth++;
    }
    return depth;
}
// LC-energy test suite (TypeScript) — TreeNode single case.
class TreeNode {
    constructor(val, left, right) {
        this.val = (val === undefined ? 0 : val);
        this.left = (left === undefined ? null : left);
        this.right = (right === undefined ? null : right);
    }
}
const _lc_root = new TreeNode(3, new TreeNode(9), new TreeNode(20, new TreeNode(15), new TreeNode(7)));
const _lc_result = minDepth(_lc_root);
if (_lc_result === undefined || _lc_result === null) {
    console.log('void');
}
