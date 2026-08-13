<?php
// LC-energy test suite (PHP) — cousins-in-binary-tree.
class TreeNode {
    public $val = 0; public $left = null; public $right = null;
    function __construct($val) { $this->val = $val; }
}
// LC accepted PHP code ships WITHOUT a `<?php` tag, so require_once
// would treat it as plain text and never define the class. Load the
// source, strip any leading tag, and eval so the class/functions bind.
$__lc_src = file_get_contents(__DIR__ . '/solution.php');
$__lc_src = preg_replace('/^\s*<\?php/', '', $__lc_src, 1);
eval($__lc_src);
$root = new TreeNode(1);
$root->left  = new TreeNode(2); $root->left->right  = new TreeNode(4);
$root->right = new TreeNode(3); $root->right->right = new TreeNode(5);
if (class_exists('Solution')) { $__lc = (new Solution())->isCousins($root, 4, 5); }
else { $__lc = isCousins($root, 4, 5); }
if (!$r) echo "unexpected\n";
