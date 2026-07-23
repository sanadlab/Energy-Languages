<?php
// LC-energy test suite (PHP) — hardcoded single case.
require_once 'solution.php';
$sol = new Solution();
$_ = $sol->ladderLength("abcde", "abcde", array("a","b","c"));
