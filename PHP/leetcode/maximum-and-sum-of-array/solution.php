class Solution {
    function maximumANDSum($nums, $numSlots) {
        $n = count($nums);
        $full = (1 << $n) - 1;
        $dp = array_fill(0, 1 << $n, -1);
        $dp[0] = 0;
        for ($slot = 1; $slot <= $numSlots; $slot++) {
            $ndp = $dp;
            for ($mask = 0; $mask <= $full; $mask++) {
                if ($dp[$mask] < 0) continue;
                $base = $dp[$mask];
                for ($i = 0; $i < $n; $i++) {
                    if (($mask >> $i) & 1) continue;
                    $nm = $mask | (1 << $i);
                    $v = $base + ($nums[$i] & $slot);
                    if ($v > $ndp[$nm]) $ndp[$nm] = $v;
                    for ($j = $i + 1; $j < $n; $j++) {
                        if (($mask >> $j) & 1) continue;
                        $nm2 = $nm | (1 << $j);
                        $v2 = $v + ($nums[$j] & $slot);
                        if ($v2 > $ndp[$nm2]) $ndp[$nm2] = $v2;
                    }
                }
            }
            $dp = $ndp;
        }
        return $dp[$full] < 0 ? 0 : $dp[$full];
    }
}
