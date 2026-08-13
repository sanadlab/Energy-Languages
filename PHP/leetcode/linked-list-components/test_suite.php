<?php
// LC-energy test suite (PHP) — linked-list-components.
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
$h = new ListNode(0); $h->next = new ListNode(1); $h->next->next = new ListNode(2); $h->next->next->next = new ListNode(3);
if (class_exists('Solution')) { $__lc = (new Solution())->numComponents($h, array(0, 1, 3)); }
else { $__lc = numComponents($h, array(0, 1, 3)); }
if ($r < 0) echo "$r\n";
