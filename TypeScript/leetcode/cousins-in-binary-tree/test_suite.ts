// LC-energy test suite (TypeScript) — cousins-in-binary-tree.
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
