class Solution {

    /**
     * @param Integer[] $nums
     * @param Integer $k
     * @return Boolean
     */
    function kLengthApart($nums, $k) {
        $prev = -1;
        $n = count($nums);
        for ($i = 0; $i < $n; $i++) {
            if ($nums[$i] == 1) {
                if ($prev != -1 && $i - $prev - 1 < $k) {
                    return false;
                }
                $prev = $i;
            }
        }
        return true;
    }
}
