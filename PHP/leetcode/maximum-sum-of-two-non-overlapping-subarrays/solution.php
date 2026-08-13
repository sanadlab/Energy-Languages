class Solution {
    private function best($pre, $n, $L, $M) {
        $res = 0; $maxL = 0;
        for ($i = $L + $M; $i <= $n; $i++) {
            $maxL = max($maxL, $pre[$i - $M] - $pre[$i - $M - $L]);
            $res = max($res, $maxL + $pre[$i] - $pre[$i - $M]);
        }
        return $res;
    }
    /**
     * @param Integer[] $nums
     * @param Integer $firstLen
     * @param Integer $secondLen
     * @return Integer
     */
    function maxSumTwoNoOverlap($nums, $firstLen, $secondLen) {
        $n = count($nums);
        $pre = array_fill(0, $n + 1, 0);
        for ($i = 0; $i < $n; $i++) $pre[$i + 1] = $pre[$i] + $nums[$i];
        return max($this->best($pre, $n, $firstLen, $secondLen), $this->best($pre, $n, $secondLen, $firstLen));
    }
}
