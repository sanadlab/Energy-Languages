class Solution {

    /**
     * @param Integer[] $nums
     * @return Integer
     */
    function maxEqualFreq($nums) {
        $n = count($nums);
        $cnt = array_fill(0, 100001, 0);
        $freq = array_fill(0, $n + 1, 0);
        $maxF = 0;
        $res = 0;
        for ($i = 0; $i < $n; $i++) {
            $v = $nums[$i];
            if ($cnt[$v] > 0) $freq[$cnt[$v]]--;
            $cnt[$v]++;
            $freq[$cnt[$v]]++;
            if ($cnt[$v] > $maxF) $maxF = $cnt[$v];
            if ($maxF == 1 ||
                $freq[$maxF] * $maxF == $i ||
                ($freq[$maxF] == 1 && ($maxF - 1) * ($freq[$maxF - 1] + 1) == $i)) {
                $res = $i + 1;
            }
        }
        return $res;
    }
}
