class Solution {
    public function countMaxOrSubsets(array $nums): int {
        $n = count($nums);
        $max_or = 0;
        foreach ($nums as $num) {
            $max_or |= $num;
        }
        
        $count = 0;
        for ($bitmask = 1; $bitmask < (1 << $n); $bitmask++) {
            $current_or = 0;
            for ($j = 0; $j < $n; $j++) {
                if (($bitmask & (1 << $j)) != 0) {
                    $current_or |= $nums[$j];
                }
            }
            if ($current_or == $max_or) {
                $count++;
            }
        }
        return $count;
    }
}