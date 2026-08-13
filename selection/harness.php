<?php
// Generic PHP loop-harness for the cross-language transfer check.
// Reads the SAME shared JSON inputs, calls the solution, loops to a wall-time
// budget (checksum-consumed, iteration-counted). PHP is dynamic, so plain-data
// args pass straight through; only tree/list/design need construction.
//
//   php harness.php <budget_seconds> <case_index>   (run from the PHP cell dir)
//   prints CASE/ITERS/ACC/BEACON to STDERR (stdout stays empty).
//
// NOTE: LeetCode PHP solutions ship WITHOUT a leading `<?php` tag; we strip any
// stray leading tag and eval() the source. We sniff `class Solution` vs a
// top-level function (design problems use the class named in ops[0]).

// ---- node types (LeetCode-style, public props) --------------------------
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

// ---- checksum (mirrors harness.js: 32-bit signed folds) -----------------
function i32($n) { $n = $n & 0xFFFFFFFF; if ($n >= 0x80000000) $n -= 0x100000000; return $n; }
function canon($r) {
    if ($r instanceof ListNode) return json_encode(listToArr($r));
    if ($r instanceof TreeNode) return json_encode(treeToArr($r));
    $s = json_encode($r);
    return $s === false ? strval($r) : $s;
}
function fold($acc, $r) {
    $h = 0; $s = canon($r); $len = strlen($s);
    for ($i = 0; $i < $len; $i++) { $h = i32($h * 31 + ord($s[$i])); }
    return i32($acc * 1000003 + $h);
}

function now() { return hrtime(true); }               // nanoseconds (int)
function secs($a, $b) { return ($b - $a) / 1e9; }

// ---- locate cell / inputs -----------------------------------------------
$cell = getcwd();
$slug = basename($cell);
$ref  = $cell . '/../../../reference/leetcode';
$out  = json_decode(file_get_contents($ref . '/outputs/' . $slug . '.json'), true);
$budget = floatval($argv[1]);
$idx    = intval($argv[2]);
$kase  = $out['expected'][$idx];
$input = $kase['input'];

// ---- load the solution (strip stray leading <?php, eval) ----------------
$src = file_get_contents($cell . '/solution.php');
$src = preg_replace('/^\xEF\xBB\xBF/', '', $src);          // strip UTF-8 BOM
$src = preg_replace('/^\s*<\?php\b/', '', $src, 1);        // strip a leading long open tag
$src = preg_replace('/^\s*<\?/', '', $src, 1);             // strip a leading short open tag
$src = preg_replace('/\?' . '>\s*$/', '', $src, 1);        // strip a trailing close tag
$before = get_declared_classes();
eval($src);
$newClasses = array_values(array_diff(get_declared_classes(), $before));

if (isset($input['ops']) && isset($input['args'])) {
    // ---- design-class replay --------------------------------------------
    $ops = $input['ops']; $args = $input['args'];
    // Prefer the class named in ops[0]; fall back to Solution or the sole
    // class the solution defined (LC PHP cells sometimes name it "Solution").
    $cls = null;
    if (class_exists($ops[0])) $cls = $ops[0];
    elseif (class_exists('Solution')) $cls = 'Solution';
    elseif (count($newClasses)) $cls = $newClasses[0];
    else fwrite(STDERR, "ERROR: no design class for {$ops[0]}\n");

    $replay = function() use ($cls, $ops, $args) {
        $inst = new $cls(...$args[0]);
        $a = 0;
        for ($i = 1; $i < count($ops); $i++) { $a = fold($a, $inst->{$ops[$i]}(...$args[$i])); }
        return $a;
    };
    // stateful replay -> args cloned each pass (kept); batch the clock read.
    $acc = 0; $iters = 0;
    $wi = 0; $tw = now(); while (secs($tw, now()) < $budget * 0.3) { $replay(); $wi++; }
    $per = $wi ? secs($tw, now()) / $wi : $budget * 0.3;
    $batch = $per > 0 ? max(1, min(4096, intval(0.002 / $per))) : 4096;
    $tm = now();
    while (secs($tm, now()) < $budget * 0.7) { for ($b = 0; $b < $batch; $b++) { $acc = fold($acc, $replay()); } $iters += $batch; }
    $ms = sprintf('%.6f', secs($tm, now()));
    fwrite(STDERR, "CASE={$kase['name']} ITERS=$iters ACC=$acc MEAS_S=$ms BEACON=design\n");
} else {
    // ---- normal call ----------------------------------------------------
    $wl = json_decode(file_get_contents($ref . '/workloads/' . $slug . '.json'), true);
    $ep = strval($wl['entry_point'] ?? '');
    $parts = explode('.', $ep); $method = end($parts);

    $keys = array_keys($input);
    // fresh args each call (rebuild tree/list; plain data copies by value)
    $makeArgs = function() use ($input, $keys) {
        $a = [];
        foreach ($keys as $k) {
            if ($k === 'root')      $a[] = buildTree($input[$k]);
            elseif ($k === 'head')  $a[] = buildList($input[$k]);
            else                    $a[] = $input[$k];
        }
        return $a;
    };

    $hasSol = class_exists('Solution');
    $invoke = function($a) use ($hasSol, $method) {
        return $hasSol ? (new Solution())->$method(...$a) : $method(...$a);
    };
    // (1) detect mutation once; reuse the built args when the solution leaves
    //     them untouched. Plain-data args are copy-on-write (the callee cannot
    //     mutate the caller's copy); only mutated tree/list objects get rebuilt.
    $base = $makeArgs();
    $snap = implode("\x1e", array_map('canon', $base));
    $beacon = $invoke($base);
    $mutated = implode("\x1e", array_map('canon', $base)) !== $snap;
    $one = $mutated ? (function() use ($invoke, $makeArgs) { return $invoke($makeArgs()); })
                    : (function() use ($invoke, $base) { return $invoke($base); });
    // (3) estimate per-iter cost during warmup, then batch the wall-clock read
    $acc = 0; $iters = 0;
    $wi = 0; $tw = now(); while (secs($tw, now()) < $budget * 0.3) { $one(); $wi++; }
    $per = $wi ? secs($tw, now()) / $wi : $budget * 0.3;
    $batch = $per > 0 ? max(1, min(4096, intval(0.002 / $per))) : 4096;
    $tm = now();
    while (secs($tm, now()) < $budget * 0.7) { for ($b = 0; $b < $batch; $b++) { $acc = fold($acc, $one()); } $iters += $batch; }
    $ms = sprintf('%.6f', secs($tm, now()));
    $b = substr(canon($beacon), 0, 80);
    fwrite(STDERR, "CASE={$kase['name']} ITERS=$iters ACC=$acc MEAS_S=$ms BEACON=$b\n");
}
