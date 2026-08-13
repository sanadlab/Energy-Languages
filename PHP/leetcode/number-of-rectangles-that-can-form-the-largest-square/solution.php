class Solution {

    /**
     * @param Integer[][] $rectangles
     * @return Integer
     */
    function countGoodRectangles($rectangles) {
        $maxLen = 0;
        $count = 0;
        foreach ($rectangles as $r) {
            $side = is_array($r) ? min($r[0], $r[1]) : $r;
            if ($side > $maxLen) { $maxLen = $side; $count = 1; }
            elseif ($side == $maxLen) { $count++; }
        }
        return $count;
    }
}
