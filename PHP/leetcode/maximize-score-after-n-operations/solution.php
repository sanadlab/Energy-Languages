class Solution {
    function maxScore($nums) {
        $m = count($nums);
        $dp = array_fill(0, 1 << $m, 0);
        $best = 0;
        for ($mask = 0; $mask < (1 << $m); $mask++) {
            $cnt = 0; for ($x = $mask; $x > 0; $x >>= 1) $cnt += $x & 1;
            if ($cnt & 1) continue;
            $op = intdiv($cnt, 2) + 1;
            for ($i = 0; $i < $m; $i++) {
                if (($mask >> $i) & 1) continue;
                for ($j = $i + 1; $j < $m; $j++) {
                    if (($mask >> $j) & 1) continue;
                    $nm = $mask | (1 << $i) | (1 << $j);
                    $val = $dp[$mask] + $op * $this->gcd($nums[$i], $nums[$j]);
                    if ($val > $dp[$nm]) $dp[$nm] = $val;
                    if ($dp[$nm] > $best) $best = $dp[$nm];
                }
            }
        }
        return $best;
    }
    function gcd($a, $b) { while ($b != 0) { $t = $a % $b; $a = $b; $b = $t; } return $a; }
}
