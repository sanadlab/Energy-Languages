// LC-energy test suite (JavaScript) — TreeNode single case.
function TreeNode(val, left, right) {
    this.val = (val === undefined ? 0 : val);
    this.left = (left === undefined ? null : left);
    this.right = (right === undefined ? null : right);
}
const path = require('path');
const src = require('fs').readFileSync(path.join(__dirname, 'solution.js'), 'utf8');
eval(src);
const root = new TreeNode(3, new TreeNode(9), new TreeNode(20, new TreeNode(15), new TreeNode(7)));
const _lc = (typeof Solution !== 'undefined') ? new Solution().minDepth(root) : minDepth(root);
