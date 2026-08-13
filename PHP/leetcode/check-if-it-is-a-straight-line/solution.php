class Solution {

    /**
     * @param Integer[][] $coordinates
     * @return Boolean
     */
    function checkStraightLine($coordinates) {
        $n = count($coordinates);
        if ($n == 2) return true;

        // Calculate the initial slope using the first two points
        $x0 = $coordinates[0][0];
        $y0 = $coordinates[0][1];
        $x1 = $coordinates[1][0];
        $y1 = $coordinates[1][1];

        $dx = $x1 - $x0;
        $dy = $y1 - $y0;

        // To avoid division and floating point precision issues,
        // we use cross multiplication to check slope equality:
        // (y2 - y1) * (x1 - x0) == (y1 - y0) * (x2 - x1)

        for ($i = 2; $i < $n; $i++) {
            $x = $coordinates[$i][0];
            $y = $coordinates[$i][1];

            if (($y - $y0) * $dx !== $dy * ($x - $x0)) {
                return false;
            }
        }

        return true;
    }
}