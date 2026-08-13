class Solution {

    /**
     * @param Integer[][] $fruits
     * @param Integer $startPos
     * @param Integer $k
     * @return Integer
     */
    function maxTotalFruits($fruits, $startPos, $k) {
        $n = count($fruits);
        $best = 0;
        $sum = 0;
        $i = 0;
        for ($j = 0; $j < $n; $j++) {
            $sum += $fruits[$j][1];
            while ($i <= $j && $this->cost($fruits[$i][0], $fruits[$j][0], $startPos) > $k) {
                $sum -= $fruits[$i][1];
                $i++;
            }
            if ($i <= $j && $sum > $best) $best = $sum;
        }
        return $best;
    }

    private function cost($posL, $posR, $startPos) {
        if ($posR <= $startPos) return $startPos - $posL;
        if ($posL >= $startPos) return $posR - $startPos;
        return ($posR - $posL) + min($startPos - $posL, $posR - $startPos);
    }
}
