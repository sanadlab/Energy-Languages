class Solution {

    /**
     * @param Integer[] $arr
     * @return Integer
     */
    function numFactoredBinaryTrees($arr) {
        sort($arr);
        $MOD = 1000000007;
        $dp = [];
        $ans = 0;
        $n = count($arr);
        for ($i = 0; $i < $n; $i++) {
            $cnt = 1;
            for ($j = 0; $j < $i; $j++) {
                if ($arr[$i] % $arr[$j] == 0) {
                    $b = intdiv($arr[$i], $arr[$j]);
                    if (isset($dp[$b])) {
                        $cnt = ($cnt + $dp[$arr[$j]] * $dp[$b]) % $MOD;
                    }
                }
            }
            $dp[$arr[$i]] = $cnt;
            $ans = ($ans + $cnt) % $MOD;
        }
        return $ans;
    }
}
