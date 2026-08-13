class Solution {

    /**
     * @param Integer[][] $grid
     * @param Integer $k
     * @return Integer[][]
     */
    function shiftGrid($grid, $k) {
        $m = count($grid);
        if ($m == 0) return $grid;
        $n = is_array($grid[0]) ? count($grid[0]) : 0;
        if ($n == 0) return $grid;
        $total = $m * $n;
        $k %= $total;
        $flat = [];
        for ($i = 0; $i < $m; $i++)
            for ($j = 0; $j < $n; $j++)
                $flat[] = $grid[$i][$j];
        $res = [];
        for ($i = 0; $i < $m; $i++) $res[$i] = array_fill(0, $n, 0);
        for ($idx = 0; $idx < $total; $idx++) {
            $np = ($idx + $k) % $total;
            $res[intdiv($np, $n)][$np % $n] = $flat[$idx];
        }
        return $res;
    }
}
