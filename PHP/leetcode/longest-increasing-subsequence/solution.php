class Solution {

    /**
     * @param Integer[] $nums
     * @return Integer
     */
    function lengthOfLIS($nums) {
        $tails = array();
        foreach ($nums as $x) {
            $lo = 0; $hi = count($tails);
            while ($lo < $hi) {
                $mid = intdiv($lo + $hi, 2);
                if ($tails[$mid] < $x) $lo = $mid + 1;
                else $hi = $mid;
            }
            $tails[$lo] = $x;
        }
        return count($tails);
    }
}
