class Solution {

    /**
     * @param Integer[][] $points
     * @return Integer
     */
    function maxPoints($points) {
        $n = count($points);
        if ($n <= 2) return $n;
        $best = 1;
        for ($i = 0; $i < $n; $i++) {
            $slopes = array();
            for ($j = $i + 1; $j < $n; $j++) {
                $dx = $points[$j][0] - $points[$i][0];
                $dy = $points[$j][1] - $points[$i][1];
                if ($dx == 0 && $dy == 0) continue;
                $g = $this->gcd(abs($dx), abs($dy));
                $dx = intdiv($dx, $g);
                $dy = intdiv($dy, $g);
                if ($dx < 0 || ($dx == 0 && $dy < 0)) { $dx = -$dx; $dy = -$dy; }
                $key = $dx . '_' . $dy;
                $c = (isset($slopes[$key]) ? $slopes[$key] : 0) + 1;
                $slopes[$key] = $c;
                if ($c + 1 > $best) $best = $c + 1;
            }
        }
        return $best;
    }

    private function gcd($a, $b) {
        while ($b != 0) { $t = $b; $b = $a % $b; $a = $t; }
        return $a;
    }
}
