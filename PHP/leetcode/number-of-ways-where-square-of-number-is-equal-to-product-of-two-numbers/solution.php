class Solution {
    private function helper($a, $b) {
        $cnt = 0;
        foreach ($a as $x) {
            $t = $x * $x;
            $seen = array();
            foreach ($b as $y) {
                if ($t % $y === 0) {
                    $need = intdiv($t, $y);
                    if (isset($seen[$need])) $cnt += $seen[$need];
                }
                if (isset($seen[$y])) $seen[$y]++; else $seen[$y] = 1;
            }
        }
        return $cnt;
    }
    /**
     * @param Integer[] $nums1
     * @param Integer[] $nums2
     * @return Integer
     */
    function numTriplets($nums1, $nums2) {
        return $this->helper($nums1, $nums2) + $this->helper($nums2, $nums1);
    }
}
