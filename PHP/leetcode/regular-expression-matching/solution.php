class Solution {

    /**
     * @param String $s
     * @param String $p
     * @return Boolean
     */
    function isMatch($s, $p) {
        $m = strlen($s); $n = strlen($p);
        $dp = array_fill(0, $m + 1, array_fill(0, $n + 1, false));
        $dp[$m][$n] = true;
        for ($i = $m; $i >= 0; $i--) {
            for ($j = $n - 1; $j >= 0; $j--) {
                $first = $i < $m && ($p[$j] === $s[$i] || $p[$j] === '.');
                if ($j + 1 < $n && $p[$j + 1] === '*') {
                    $dp[$i][$j] = $dp[$i][$j + 2] || ($first && $dp[$i + 1][$j]);
                } else {
                    $dp[$i][$j] = $first && $dp[$i + 1][$j + 1];
                }
            }
        }
        return $dp[0][0];
    }
}
