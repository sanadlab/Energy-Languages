class Solution {
    /**
     * @param String $s
     * @return Integer
     */
    function minOperations($s) {
        $cnt = 0;
        $n = strlen($s);
        for ($i = 0; $i < $n; $i++) {
            $expected = ($i % 2 == 0) ? '0' : '1';
            if ($s[$i] !== $expected) $cnt++;
        }
        return min($cnt, $n - $cnt);
    }
}
