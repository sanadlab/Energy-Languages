class Solution {
    /**
     * @param String[][] $seats
     * @return Integer
     */
    function maxStudents($seats) {
        $m = count($seats);
        if ($m == 0) return 0;
        $n = count($seats[0]);
        $avail = array_fill(0, $m, 0);
        for ($i = 0; $i < $m; $i++)
            for ($j = 0; $j < $n && $j < count($seats[$i]); $j++)
                if ($seats[$i][$j] === '.') $avail[$i] |= (1 << $j);
        $full = 1 << $n;
        $best = array_fill(0, $full, -1);
        $best[0] = 0;
        for ($i = 0; $i < $m; $i++) {
            $ndp = array_fill(0, $full, -1);
            for ($mask = 0; $mask < $full; $mask++) {
                if (($mask & $avail[$i]) !== $mask) continue;
                if (($mask & ($mask << 1)) !== 0) continue;
                $pc = substr_count(decbin($mask), '1');
                for ($pmask = 0; $pmask < $full; $pmask++) {
                    if ($best[$pmask] < 0) continue;
                    if (($mask & ($pmask << 1)) !== 0) continue;
                    if (($mask & ($pmask >> 1)) !== 0) continue;
                    $val = $best[$pmask] + $pc;
                    if ($val > $ndp[$mask]) $ndp[$mask] = $val;
                }
            }
            $best = $ndp;
        }
        return max($best);
    }
}
