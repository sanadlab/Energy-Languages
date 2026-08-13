<?php
// LC-energy test suite (PHP) — middle-of-the-linked-list.
class ListNode {
    public $val = 0; public $next = null;
    function __construct($val) { $this->val = $val; }
}
// LC accepted PHP code ships WITHOUT a `<?php` tag, so require_once
// would treat it as plain text and never define the class. Load the
// source, strip any leading tag, and eval so the class/functions bind.
$__lc_src = file_get_contents(__DIR__ . '/solution.php');
$__lc_src = preg_replace('/^\s*<\?php/', '', $__lc_src, 1);
eval($__lc_src);
$h = new ListNode(1); $c = $h;
foreach ([2,3,4,5] as $v) { $c->next = new ListNode($v); $c = $c->next; }
if (class_exists('Solution')) { $__lc = (new Solution())->middleNode($h); }
else { $__lc = middleNode($h); }
if ($r === null) echo "null\n";
