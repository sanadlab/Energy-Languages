class Solution {

    /**
     * @param Integer $n
     * @return Integer
     */
    function clumsy($n) {
        $stack = [];
        $stack[] = $n;
        $n--;
        $i = 0; // operation index: 0->*, 1->/, 2->+, 3->-
        while ($n > 0) {
            if ($i % 4 == 0) {
                // multiply
                $top = array_pop($stack);
                $stack[] = $top * $n;
            } elseif ($i % 4 == 1) {
                // divide (floor division)
                $top = array_pop($stack);
                // floor division towards zero for positive numbers is just intdiv
                $stack[] = intdiv($top, $n);
            } elseif ($i % 4 == 2) {
                // add
                $stack[] = $n;
            } else {
                // subtract
                $stack[] = -$n;
            }
            $n--;
            $i++;
        }
        return array_sum($stack);
    }
}