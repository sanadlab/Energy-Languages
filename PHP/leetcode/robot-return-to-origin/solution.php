class Solution {

    /**
     * @param String $moves
     * @return Boolean
     */
    function judgeCircle($moves) {
        $x = 0; $y = 0;
        $len = strlen($moves);
        for ($i = 0; $i < $len; $i++) {
            switch ($moves[$i]) {
                case 'U': $y++; break;
                case 'D': $y--; break;
                case 'L': $x--; break;
                case 'R': $x++; break;
            }
        }
        return $x === 0 && $y === 0;
    }
}
