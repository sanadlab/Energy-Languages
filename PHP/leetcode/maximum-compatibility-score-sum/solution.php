class Solution {
    function maxCompatibilitySum($students, $mentors) {
        $m = count($students);
        $n = ($m > 0 && is_array($students[0])) ? count($students[0]) : 0;
        $score = array_fill(0, $m, array_fill(0, $m, 0));
        for ($i = 0; $i < $m; $i++)
            for ($j = 0; $j < $m; $j++)
                for ($k = 0; $k < $n; $k++)
                    if ($students[$i][$k] === $mentors[$j][$k]) $score[$i][$j]++;
        $dp = array_fill(0, 1 << $m, 0);
        for ($mask = 0; $mask < (1 << $m); $mask++) {
            $cnt = 0; for ($x = $mask; $x > 0; $x >>= 1) $cnt += $x & 1;
            if ($cnt >= $m) continue;
            for ($j = 0; $j < $m; $j++) {
                if (($mask >> $j) & 1) continue;
                $nm = $mask | (1 << $j);
                $val = $dp[$mask] + $score[$cnt][$j];
                if ($val > $dp[$nm]) $dp[$nm] = $val;
            }
        }
        return $dp[(1 << $m) - 1];
    }
}
