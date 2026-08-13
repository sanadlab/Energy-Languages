class Solution {

    /**
     * @param Integer[] $stones
     * @return Boolean
     */
    function canCross($stones) {
        $n = count($stones);
        // Map stone position to its index for O(1) lookup
        $posIndex = [];
        for ($i = 0; $i < $n; $i++) {
            $posIndex[$stones[$i]] = $i;
        }

        // dp[i] = set of jump sizes that can land on stone i
        $dp = array_fill(0, $n, []);
        $dp[0] = [0 => true]; // At stone 0, last jump was 0

        for ($i = 0; $i < $n; $i++) {
            foreach ($dp[$i] as $k => $_) {
                // next jump can be k-1, k, k+1 but > 0
                for ($step = $k - 1; $step <= $k + 1; $step++) {
                    if ($step <= 0) continue;
                    $nextPos = $stones[$i] + $step;
                    if (isset($posIndex[$nextPos])) {
                        $nextIndex = $posIndex[$nextPos];
                        $dp[$nextIndex][$step] = true;
                        if ($nextIndex == $n - 1) {
                            return true;
                        }
                    }
                }
            }
        }

        return false;
    }
}