// LC-energy test suite (JavaScript) — cousins-in-binary-tree.
function TreeNode(val, left, right) {
    this.val = val;
    this.left = left || null;
    this.right = right || null;
}
eval(require('fs').readFileSync(__dirname + '/solution.js', 'utf8'));

const root = new TreeNode(1,
    new TreeNode(2, null, new TreeNode(4)),
    new TreeNode(3, null, new TreeNode(5))
);
const _lc = (typeof Solution !== 'undefined')
  ? new Solution().isCousins(root, 4, 5)
  : isCousins(root, 4, 5);
if (!_lc) console.log("unexpected");
