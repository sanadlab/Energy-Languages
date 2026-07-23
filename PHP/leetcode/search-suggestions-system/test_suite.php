<?php
// LC-energy test suite (PHP) — hardcoded single case.
require_once 'solution.php';
$sol = new Solution();
$_ = $sol->suggestedProducts(array("a","b","c"), "abcde");
