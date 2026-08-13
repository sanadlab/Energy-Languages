class Solution {
    /**
     * @param Integer[][] $points
     * @return Integer
     */
    function minAreaRect($points) {
        $seen = array();
        $n = count($points);
        foreach ($points as $p) $seen[$p[0] * 50000 + $p[1]] = true;
        $best = PHP_INT_MAX;
        for ($i = 0; $i < $n; $i++) {
            for ($j = $i + 1; $j < $n; $j++) {
                $x1 = $points[$i][0]; $y1 = $points[$i][1];
                $x2 = $points[$j][0]; $y2 = $points[$j][1];
                if ($x1 != $x2 && $y1 != $y2) {
                    if (isset($seen[$x1 * 50000 + $y2]) && isset($seen[$x2 * 50000 + $y1])) {
                        $area = abs($x1 - $x2) * abs($y1 - $y2);
                        if ($area < $best) $best = $area;
                    }
                }
            }
        }
        return $best == PHP_INT_MAX ? 0 : $best;
    }
}
