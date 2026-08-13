class Solution {
    function splitArray($nums, $k) {
        $lo = 0; $hi = 0;
        foreach ($nums as $x) { if ($x > $lo) $lo = $x; $hi += $x; }
        while ($lo < $hi) {
            $mid = intdiv($lo + $hi, 2);
            $cnt = 1; $cur = 0;
            foreach ($nums as $x) {
                if ($cur + $x > $mid) { $cnt++; $cur = $x; }
                else $cur += $x;
            }
            if ($cnt <= $k) $hi = $mid;
            else $lo = $mid + 1;
        }
        return $lo;
    }
}
