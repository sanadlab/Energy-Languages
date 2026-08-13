<?php
// LC-energy test suite (PHP) — hardcoded single case.
// LC accepted PHP code ships WITHOUT a `<?php` tag, so require_once
// would treat it as plain text and never define the class. Load the
// source, strip any leading tag, and eval so the class/functions bind.
$__lc_src = file_get_contents(__DIR__ . '/solution.php');
$__lc_src = preg_replace('/^\s*<\?php/', '', $__lc_src, 1);
eval($__lc_src);
if (class_exists('Solution')) { $sol = new Solution(); $_ = $sol->average(array(1,2,3,4,5)); }
else { $_ = average(array(1,2,3,4,5)); }
