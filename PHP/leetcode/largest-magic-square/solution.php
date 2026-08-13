class Solution {
    function largestMagicSquare($grid) {
        $m = count($grid);
        if ($m == 0) return 0;
        $n = is_array($grid[0]) ? count($grid[0]) : 0;
        if ($n == 0) return 1;
        $maxK = min($m, $n);
        for ($k = $maxK; $k >= 1; $k--) {
            for ($i = 0; $i + $k <= $m; $i++) {
                for ($j = 0; $j + $k <= $n; $j++) {
                    if ($this->isMagic($grid, $i, $j, $k)) return $k;
                }
            }
        }
        return 1;
    }

    private function isMagic($grid, $r, $c, $k) {
        $target = 0;
        for ($j = 0; $j < $k; $j++) $target += $grid[$r][$c + $j];
        for ($i = 0; $i < $k; $i++) {
            $s = 0;
            for ($j = 0; $j < $k; $j++) $s += $grid[$r + $i][$c + $j];
            if ($s != $target) return false;
        }
        for ($j = 0; $j < $k; $j++) {
            $s = 0;
            for ($i = 0; $i < $k; $i++) $s += $grid[$r + $i][$c + $j];
            if ($s != $target) return false;
        }
        $d1 = 0; $d2 = 0;
        for ($i = 0; $i < $k; $i++) {
            $d1 += $grid[$r + $i][$c + $i];
            $d2 += $grid[$r + $i][$c + $k - 1 - $i];
        }
        return $d1 == $target && $d2 == $target;
    }
}
