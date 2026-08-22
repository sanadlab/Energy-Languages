<?php
ini_set('memory_limit', '2048M');  // offline validator: heavy tries (e.g. 2000-word) exceed the 128M default
// Full-suite correctness validator (PHP). Runs solution.php against EVERY
// reference case and compares each result to the expected output. Run FROM the
// cell dir:  php ../../../selection/validate_suite.php
// Reuses harness.php's tree/list/canon logic so correctness judges the exact
// same shared inputs the measurement harness does.
// Prints one VALIDATE line to STDERR. Exit: 0 Accepted, 1 Wrong Answer,
// 3 Runtime Error, 2 setup error.

class TreeNode { public $val; public $left = null; public $right = null;
    function __construct($v = 0) { $this->val = $v; } }
class ListNode { public $val; public $next = null;
    function __construct($v = 0) { $this->val = $v; } }

function buildTree($a) {
    if (!is_array($a) || count($a) === 0 || $a[0] === null) return null;
    $root = new TreeNode($a[0]); $q = [$root]; $qi = 0; $i = 1; $n = count($a);
    while ($i < $n && $qi < count($q)) {
        $node = $q[$qi++];
        if ($i < $n) { $lv = $a[$i++]; if ($lv !== null) { $node->left  = new TreeNode($lv); $q[] = $node->left; } }
        if ($i < $n) { $rv = $a[$i++]; if ($rv !== null) { $node->right = new TreeNode($rv); $q[] = $node->right; } }
    }
    return $root;
}
function buildList($a) {
    if (!is_array($a) || count($a) === 0) return null;
    $head = new ListNode($a[0]); $c = $head;
    for ($i = 1; $i < count($a); $i++) { $c->next = new ListNode($a[$i]); $c = $c->next; }
    return $head;
}
function treeToArr($r) {
    $a = []; $q = [$r]; $qi = 0;
    while ($qi < count($q)) {
        $n = $q[$qi++];
        if ($n === null) { $a[] = null; }
        else { $a[] = $n->val; $q[] = $n->left; $q[] = $n->right; }
    }
    while (count($a) && end($a) === null) array_pop($a);
    return $a;
}
function listToArr($h) { $a = []; while ($h !== null) { $a[] = $h->val; $h = $h->next; } return $a; }
function canon($r) {
    if ($r instanceof ListNode) return json_encode(listToArr($r));
    if ($r instanceof TreeNode) return json_encode(treeToArr($r));
    $s = json_encode($r);
    return $s === false ? strval($r) : $s;
}
// design/trace: a null in expected marks a void op (LeetCode discards its
// return); compare strictly only at value-returning positions.
function seq_ok($actual, $expected) {
    if (!is_array($actual) || !is_array($expected) || count($actual) !== count($expected)) return false;
    for ($i = 0; $i < count($expected); $i++) {
        if ($expected[$i] === null) continue;
        if (canon($actual[$i]) !== canon($expected[$i])) return false;
    }
    return true;
}

$cell = getcwd();
$slug = basename($cell);
$ref  = $cell . '/../../../reference/leetcode';

$out = @json_decode(@file_get_contents($ref . '/outputs/' . $slug . '.json'), true);
$wl  = @json_decode(@file_get_contents($ref . '/workloads/' . $slug . '.json'), true);
if ($out === null || $wl === null) {
    fwrite(STDERR, "VALIDATE slug=$slug ERROR load: missing reference json\n"); exit(2);
}
$ep = strval($wl['entry_point'] ?? '');
$parts = explode('.', $ep); $method = end($parts);
$randomized = ($slug === 'random-pick-index');
// LeetCode accepts these answers in ANY order (special judge) -> multiset compare.
$UNORDERED = ['uncommon-words-from-two-sentences', 'remove-invalid-parentheses', 'restore-the-array-from-adjacent-pairs'];
function unordered_eq($a, $e) {
    if (!is_array($a) || !is_array($e)) return canon($a) === canon($e);
    $ka = array_map('canon', $a); sort($ka);
    $ke = array_map('canon', $e); sort($ke);
    return $ka === $ke;
}

// ---- load the solution (strip stray leading <?php, eval) ----------------
$src = @file_get_contents($cell . '/solution.php');
if ($src === false) { fwrite(STDERR, "VALIDATE slug=$slug ERROR load: no solution.php\n"); exit(2); }
$src = preg_replace('/^\xEF\xBB\xBF/', '', $src);
$src = preg_replace('/^\s*<\?php\b/', '', $src, 1);
$src = preg_replace('/^\s*<\?/', '', $src, 1);
$src = preg_replace('/\?' . '>\s*$/', '', $src, 1);
$before = get_declared_classes();
try { eval($src); }
catch (\Throwable $e) { fwrite(STDERR, "VALIDATE slug=$slug ERROR load: $e\n"); exit(2); }
$newClasses = array_values(array_diff(get_declared_classes(), $before));
$hasSol = class_exists('Solution');

function run_case($input, $method, $hasSol, $newClasses, $randomized) {
    if (isset($input['ops']) && isset($input['args'])) {
        $ops = $input['ops']; $args = $input['args'];
        $cls = null;
        if (class_exists($ops[0])) $cls = $ops[0];
        elseif (class_exists('Solution')) $cls = 'Solution';
        elseif (count($newClasses)) $cls = $newClasses[0];
        if ($cls === null) throw new \RuntimeException("no class {$ops[0]}");
        $nums = $randomized && isset($args[0][0]) ? $args[0][0] : null;
        $inst = new $cls(...$args[0]);
        $seq = [null];
        for ($i = 1; $i < count($ops); $i++) {
            $r = $inst->{$ops[$i]}(...$args[$i]);
            if ($randomized && $ops[$i] === 'pick' && is_int($r) && $nums !== null) $r = $nums[$r];
            $seq[] = $r;
        }
        return $seq;
    }
    $base = [];
    foreach (array_keys($input) as $k) {
        if ($k === 'root')     $base[] = buildTree($input[$k]);
        elseif ($k === 'head') $base[] = buildList($input[$k]);
        else                   $base[] = $input[$k];
    }
    return $hasSol ? (new Solution())->$method(...$base) : $method(...$base);
}

$__total = count($out['expected']);
foreach ($out['expected'] as $__i => $c) {
    $name = $c['name'];
    $input = $c['input'];
    $is_design = isset($input['ops']) && isset($input['args']);
    try {
        $actual = run_case($input, $method, $hasSol, $newClasses, $randomized);
    } catch (\Throwable $e) {
        fwrite(STDERR, "VALIDATE slug=$slug RE case=$name passed=$__i ncases=$__total " . get_class($e) . ": " . $e->getMessage() . "\n");
        exit(3);
    }
    $ok = $is_design ? seq_ok($actual, $c['output'])
         : (in_array($slug, $UNORDERED, true) ? unordered_eq($actual, $c['output']) : (canon($actual) === canon($c['output'])));
    if (!$ok) {
        fwrite(STDERR, "VALIDATE slug=$slug FAIL case=$name passed=$__i ncases=$__total "
            . "expected=" . substr(canon($c['output']), 0, 120) . " "
            . "actual="   . substr(canon($actual), 0, 120) . "\n");
        exit(1);
    }
}
fwrite(STDERR, "VALIDATE slug=$slug PASS ncases=$__total passed=$__total\n");
exit(0);
