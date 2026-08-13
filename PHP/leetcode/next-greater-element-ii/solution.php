class Solution {
    function nextGreaterElements($nums) {
        $n = count($nums);
        $res = array_fill(0, $n, -1);
        $st = array();
        for ($i = 0; $i < 2 * $n; $i++) {
            $cur = $nums[$i % $n];
            while (!empty($st) && $nums[end($st)] < $cur) {
                $res[array_pop($st)] = $cur;
            }
            if ($i < $n) $st[] = $i;
        }
        return $res;
    }
}
