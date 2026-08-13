class Solution {

    /**
     * @param Integer $n
     * @return Integer
     */
    function minSteps($n) {
        $res = 0;
        for ($d = 2; $d <= $n; $d++) {
            while ($n % $d == 0) {
                $res += $d;
                $n = intdiv($n, $d);
            }
        }
        return $res;
    }
}
