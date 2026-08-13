class Solution {
    private $parent;
    function find($x) {
        while ($this->parent[$x] != $x) {
            $this->parent[$x] = $this->parent[$this->parent[$x]];
            $x = $this->parent[$x];
        }
        return $x;
    }
    function union($a, $b) {
        $ra = $this->find($a); $rb = $this->find($b);
        if ($ra != $rb) $this->parent[$ra] = $rb;
    }

    /**
     * @param String[] $grid
     * @return Integer
     */
    function regionsBySlashes($grid) {
        $n = count($grid);
        $this->parent = range(0, 4 * $n * $n - 1);
        for ($r = 0; $r < $n; $r++) {
            for ($c = 0; $c < $n; $c++) {
                $base = 4 * ($r * $n + $c);
                $top = $base; $right = $base + 1; $bottom = $base + 2; $left = $base + 3;
                $ch = $c < strlen($grid[$r]) ? $grid[$r][$c] : ' ';
                if ($ch === '/') { $this->union($top, $left); $this->union($right, $bottom); }
                elseif ($ch === '\\') { $this->union($top, $right); $this->union($left, $bottom); }
                else { $this->union($top, $right); $this->union($right, $bottom); $this->union($bottom, $left); }
                if ($c + 1 < $n) $this->union($right, 4 * ($r * $n + $c + 1) + 3);
                if ($r + 1 < $n) $this->union($bottom, 4 * (($r + 1) * $n + $c));
            }
        }
        $cnt = 0;
        for ($i = 0; $i < 4 * $n * $n; $i++) if ($this->find($i) == $i) $cnt++;
        return $cnt;
    }
}
