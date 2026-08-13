class Solution {
    function medianSlidingWindow($nums, $k) {
        $res = array();
        $n = count($nums);
        for ($i = 0; $i + $k <= $n; $i++) {
            $w = array_slice($nums, $i, $k);
            sort($w);
            if ($k % 2 == 1) {
                $median = (float)$w[intdiv($k, 2)];
            } else {
                $median = ($w[intdiv($k,2) - 1] + $w[intdiv($k,2)]) / 2.0;
            }
            $res[] = $median;
        }
        return $res;
    }
}
