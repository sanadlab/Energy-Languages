class Solution {

    /**
     * @param Integer $n
     * @return Integer
     */
    function countTriples($n) {
        $count = 0;
        for ($a = 1; $a <= $n; $a++) {
            for ($b = 1; $b <= $n; $b++) {
                $c2 = $a * $a + $b * $b;
                $c = (int) sqrt($c2);
                if ($c <= $n && $c * $c == $c2) {
                    $count++;
                }
            }
        }
        return $count;
    }
}