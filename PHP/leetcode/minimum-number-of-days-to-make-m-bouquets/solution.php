class Solution {
    function minDays($bloomDay, $m, $k) {
        if ($m * $k > count($bloomDay)) return -1;
        $lo = min($bloomDay); $hi = max($bloomDay);
        while ($lo < $hi) {
            $mid = intdiv($lo + $hi, 2);
            if ($this->canMake($bloomDay, $m, $k, $mid)) $hi = $mid;
            else $lo = $mid + 1;
        }
        return $lo;
    }
    private function canMake($bloomDay, $m, $k, $day) {
        $bouquets = 0; $flowers = 0;
        foreach ($bloomDay as $b) {
            if ($b <= $day) {
                $flowers++;
                if ($flowers == $k) { $bouquets++; $flowers = 0; }
            } else {
                $flowers = 0;
            }
        }
        return $bouquets >= $m;
    }
}
