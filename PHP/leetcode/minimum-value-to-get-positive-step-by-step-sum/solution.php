class Solution {
    function minStartValue($nums) {
        $prefix = 0; $minPrefix = 0;
        foreach ($nums as $x) {
            $prefix += $x;
            if ($prefix < $minPrefix) $minPrefix = $prefix;
        }
        return max(1, 1 - $minPrefix);
    }
}
