class Solution {
    /**
     * @param Integer $maxTime
     * @param Integer[][] $edges
     * @param Integer[] $passingFees
     * @return Integer
     */
    function minCost($maxTime, $edges, $passingFees) {
        $n = count($passingFees);
        $INF = 1 << 29;
        $adj = array_fill(0, $n, array());
        foreach ($edges as $e) {
            if (!is_array($e) || count($e) < 3) continue;
            $x = $e[0]; $y = $e[1]; $w = $e[2];
            if ($x < 0 || $x >= $n || $y < 0 || $y >= $n || $w < 0) continue;
            $adj[$x][] = array($y, $w);
            $adj[$y][] = array($x, $w);
        }
        $dp = array();
        for ($t = 0; $t <= $maxTime; $t++) $dp[$t] = array_fill(0, $n, $INF);
        $dp[0][0] = $passingFees[0];
        $ans = $INF;
        for ($t = 0; $t <= $maxTime; $t++) {
            for ($u = 0; $u < $n; $u++) {
                $cur = $dp[$t][$u];
                if ($cur >= $INF) continue;
                if ($u == $n - 1 && $cur < $ans) $ans = $cur;
                foreach ($adj[$u] as $e) {
                    $v = $e[0]; $w = $e[1];
                    $nt = $t + $w;
                    if ($nt <= $maxTime && $cur + $passingFees[$v] < $dp[$nt][$v])
                        $dp[$nt][$v] = $cur + $passingFees[$v];
                }
            }
        }
        return $ans >= $INF ? -1 : $ans;
    }
}
