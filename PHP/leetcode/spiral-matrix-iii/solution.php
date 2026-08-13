class Solution {
    function spiralMatrixIII($rows, $cols, $rStart, $cStart) {
        $total = $rows * $cols;
        $res = array();
        $r = $rStart; $c = $cStart;
        if ($r >= 0 && $r < $rows && $c >= 0 && $c < $cols) $res[] = array($r, $c);
        $dr = array(0, 1, 0, -1);
        $dc = array(1, 0, -1, 0);
        $step = 1; $d = 0;
        while (count($res) < $total) {
            for ($t = 0; $t < 2; $t++) {
                for ($s = 0; $s < $step; $s++) {
                    $r += $dr[$d % 4];
                    $c += $dc[$d % 4];
                    if ($r >= 0 && $r < $rows && $c >= 0 && $c < $cols) $res[] = array($r, $c);
                }
                $d++;
            }
            $step++;
        }
        return $res;
    }
}
