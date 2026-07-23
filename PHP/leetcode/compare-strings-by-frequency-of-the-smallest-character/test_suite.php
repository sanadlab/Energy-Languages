<?php
// LC-energy test suite (PHP) — hardcoded single case.
require_once 'solution.php';
$sol = new Solution();
$_ = $sol->numSmallerByFrequency(array("a","b","c"), array("a","b","c"));
