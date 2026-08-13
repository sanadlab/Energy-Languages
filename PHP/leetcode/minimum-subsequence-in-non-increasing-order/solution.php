class Solution {
    function minSubsequence($nums) {
        rsort($nums);
        $total = array_sum($nums);
        $running = 0;
        $res = array();
        foreach ($nums as $x) {
            $running += $x;
            $res[] = $x;
            if ($running * 2 > $total) break;
        }
        return $res;
    }
}
