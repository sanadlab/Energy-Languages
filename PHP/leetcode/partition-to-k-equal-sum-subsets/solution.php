class Solution {
    private $nums;
    private $used;
    private $target;

    private function backtrack($k, $cur, $start) {
        if ($k === 0) return true;
        if ($cur === $this->target) return $this->backtrack($k - 1, 0, 0);
        $n = count($this->nums);
        for ($i = $start; $i < $n; $i++) {
            if ($this->used[$i] || $cur + $this->nums[$i] > $this->target) continue;
            $this->used[$i] = true;
            if ($this->backtrack($k, $cur + $this->nums[$i], $i + 1)) return true;
            $this->used[$i] = false;
            if ($cur === 0) break;
        }
        return false;
    }
    /**
     * @param Integer[] $nums
     * @param Integer $k
     * @return Boolean
     */
    function canPartitionKSubsets($nums, $k) {
        if ($k <= 0 || count($nums) < $k) return false;
        $sum = array_sum($nums);
        if ($sum % $k !== 0) return false;
        $this->target = intdiv($sum, $k);
        rsort($nums);
        if ($nums[0] > $this->target) return false;
        $this->nums = $nums;
        $this->used = array_fill(0, count($nums), false);
        return $this->backtrack($k, 0, 0);
    }
}
