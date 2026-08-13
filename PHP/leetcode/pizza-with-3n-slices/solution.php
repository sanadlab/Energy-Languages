class Solution {

    /**
     * @param Integer[] $slices
     * @return Integer
     */
    function maxSizeSlices($slices) {
        $total = count($slices);
        $k = intdiv($total, 3);
        if ($k == 0) return 0;
        $a = array_slice($slices, 0, $total - 1);
        $b = array_slice($slices, 1);
        return max($this->best($a, $k), $this->best($b, $k));
    }

    private function best($nums, $k) {
        $n = count($nums);
        $NEG = -(1 << 60);
        $dp = array();
        for ($i = 0; $i <= $n; $i++) {
            $dp[$i] = array_fill(0, $k + 1, $NEG);
            $dp[$i][0] = 0;
        }
        for ($i = 1; $i <= $n; $i++) {
            for ($j = 1; $j <= $k; $j++) {
                $skip = $dp[$i - 1][$j];
                if ($i >= 2) {
                    $prev = $dp[$i - 2][$j - 1];
                } else {
                    $prev = ($j == 1) ? 0 : $NEG;
                }
                $take = $prev + $nums[$i - 1];
                $dp[$i][$j] = max($skip, $take);
            }
        }
        return $dp[$n][$k];
    }
}
