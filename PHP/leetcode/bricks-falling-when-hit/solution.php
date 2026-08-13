class Solution {

    /**
     * @param Integer[][] $grid
     * @param Integer[][] $hits
     * @return Integer[]
     */
    function hitBricks($grid, $hits) {
        $m = is_array($grid) ? count($grid) : 0;
        $n = ($m > 0 && is_array($grid[0])) ? count($grid[0]) : 0;
        $total = $m * $n;
        $top = $total;
        $parent = range(0, $total);
        $sz = array_fill(0, $total + 1, 1);

        $find = function ($x) use (&$parent) {
            while ($parent[$x] != $x) {
                $parent[$x] = $parent[$parent[$x]];
                $x = $parent[$x];
            }
            return $x;
        };
        $union = function ($a, $b) use (&$parent, &$sz, &$find) {
            $ra = $find($a);
            $rb = $find($b);
            if ($ra == $rb) return;
            if ($sz[$ra] < $sz[$rb]) { $t = $ra; $ra = $rb; $rb = $t; }
            $parent[$rb] = $ra;
            $sz[$ra] += $sz[$rb];
        };
        $inb = function ($r, $c) use ($m, $n) {
            return $r >= 0 && $r < $m && $c >= 0 && $c < $n;
        };

        $g = array();
        for ($r = 0; $r < $m; $r++) {
            $g[$r] = array_fill(0, $n, 0);
            $row = is_array($grid[$r]) ? $grid[$r] : array();
            $len = count($row);
            for ($c = 0; $c < $n && $c < $len; $c++) {
                if ($row[$c] == 1) $g[$r][$c] = 1;
            }
        }

        foreach ($hits as $h) {
            if (!is_array($h) || count($h) < 2) continue;
            $r = $h[0]; $c = $h[1];
            if ($inb($r, $c)) $g[$r][$c] = 0;
        }

        for ($r = 0; $r < $m; $r++) {
            for ($c = 0; $c < $n; $c++) {
                if ($g[$r][$c] == 1) {
                    $cur = $r * $n + $c;
                    if ($r == 0) $union($cur, $top);
                    if ($r > 0 && $g[$r - 1][$c] == 1) $union($cur, ($r - 1) * $n + $c);
                    if ($c > 0 && $g[$r][$c - 1] == 1) $union($cur, $r * $n + $c - 1);
                }
            }
        }

        $dirs = array(array(1, 0), array(-1, 0), array(0, 1), array(0, -1));
        $res = array_fill(0, count($hits), 0);
        for ($i = count($hits) - 1; $i >= 0; $i--) {
            $h = $hits[$i];
            if (!is_array($h) || count($h) < 2) continue;
            $r = $h[0]; $c = $h[1];
            if (!$inb($r, $c)) continue;
            if (!(is_array($grid[$r]) && isset($grid[$r][$c]) && $grid[$r][$c] == 1)) continue;
            $before = $sz[$find($top)];
            $g[$r][$c] = 1;
            $cur = $r * $n + $c;
            if ($r == 0) $union($cur, $top);
            foreach ($dirs as $d) {
                $nr = $r + $d[0]; $nc = $c + $d[1];
                if ($inb($nr, $nc) && $g[$nr][$nc] == 1) $union($cur, $nr * $n + $nc);
            }
            $after = $sz[$find($top)];
            $f = $after - $before - 1;
            $res[$i] = $f > 0 ? $f : 0;
        }
        return $res;
    }
}
