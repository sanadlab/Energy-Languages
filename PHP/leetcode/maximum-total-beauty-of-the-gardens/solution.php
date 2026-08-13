class Solution {
    private function lowerBound($fl, $hiIdx, $v) {
        $lo = 0; $hi = $hiIdx;
        while ($lo < $hi) {
            $mid = intdiv($lo + $hi, 2);
            if ($fl[$mid] < $v) $lo = $mid + 1; else $hi = $mid;
        }
        return $lo;
    }
    /**
     * @param Integer[] $flowers
     * @param Integer $newFlowers
     * @param Integer $target
     * @param Integer $full
     * @param Integer $partial
     * @return Integer
     */
    function maximumBeauty($flowers, $newFlowers, $target, $full, $partial) {
        $n = count($flowers);
        if ($n == 0) return 0;
        $fl = array();
        for ($i = 0; $i < $n; $i++) $fl[] = min($flowers[$i], $target);
        sort($fl);
        $pre = array_fill(0, $n + 1, 0);
        for ($i = 0; $i < $n; $i++) $pre[$i + 1] = $pre[$i] + $fl[$i];
        if ($fl[0] == $target) return $full * $n;
        $ans = 0;
        for ($i = $n; $i >= 0; $i--) {
            $costComplete = $target * ($n - $i) - ($pre[$n] - $pre[$i]);
            if ($costComplete > $newFlowers) continue;
            $rem = $newFlowers - $costComplete;
            if ($i == 0) { $ans = max($ans, $full * ($n - $i)); continue; }
            $lo = 0; $hi = $target - 1; $bestMin = 0;
            while ($lo <= $hi) {
                $v = intdiv($lo + $hi, 2);
                $k = $this->lowerBound($fl, $i, $v);
                $cost = $v * $k - $pre[$k];
                if ($cost <= $rem) { $bestMin = $v; $lo = $v + 1; } else { $hi = $v - 1; }
            }
            $ans = max($ans, $full * ($n - $i) + $bestMin * $partial);
        }
        return $ans;
    }
}
