<?php
// LC-energy test suite (PHP) — design-a-stack-with-increment-operation.
$__lc_src = file_get_contents(__DIR__ . '/solution.php');
$__lc_src = preg_replace('/^\s*<\?php/', '', $__lc_src, 1);
eval($__lc_src);
$s = new CustomStack(5);
$s->push(1); $s->push(2); $s->push(3);
$s->increment(2, 100);
$r1 = $s->pop();
$r2 = $s->pop();
if ($r1 < 0 && $r2 < 0) { echo "unexpected\n"; }
