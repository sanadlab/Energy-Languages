<?php
// LC-energy test suite (PHP) — hardcoded single case.
require_once 'solution.php';
$sol = new Solution();
$_ = $sol->evaluate("abcde", array(array("a","b"),array("c","d")));
