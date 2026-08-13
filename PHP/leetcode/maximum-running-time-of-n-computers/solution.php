class Solution {
    /**
     * @param Integer $n
     * @param Integer[] $batteries
     * @return Integer
     */
    function maxRunTime($n, $batteries) {
        $sum = 0;
        foreach ($batteries as $b) $sum += $b;
        $lo = 0;
        $hi = intdiv($sum, $n);
        while ($lo < $hi) {
            $mid = intdiv($lo + $hi + 1, 2);
            $avail = 0;
            foreach ($batteries as $b) $avail += min($b, $mid);
            if ($avail >= $n * $mid) $lo = $mid; else $hi = $mid - 1;
        }
        return $lo;
    }
}
