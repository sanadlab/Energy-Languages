class Solution {
    public function findKDistantIndices(array $nums, int $key, int $k): array {
        $n = count($nums);
        $result = [];
        for ($i = 0; $i < $n; $i++) {
            $start = max(0, $i - $k);
            $end = min($n - 1, $i + $k);
            $found = false;
            for ($j = $start; $j <= $end; $j++) {
                if ($nums[$j] == $key) {
                    $found = true;
                    break;
                }
            }
            if ($found) {
                $result[] = $i;
            }
        }
        return $result;
    }
}