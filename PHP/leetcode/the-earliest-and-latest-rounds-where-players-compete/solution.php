class Solution {

    private $memo;

    /**
     * @param Integer $n
     * @param Integer $firstPlayer
     * @param Integer $secondPlayer
     * @return Integer[]
     */
    function earliestAndLatest($n, $firstPlayer, $secondPlayer) {
        $this->memo = [];
        return $this->dp($n, $firstPlayer, $secondPlayer);
    }

    private function dp($m, $f, $s) {
        if ($f > $s) { $t = $f; $f = $s; $s = $t; }
        if ($f + $s == $m + 1) return [1, 1];
        $key = $m * 10000 + $f * 100 + $s;
        if (isset($this->memo[$key])) return $this->memo[$key];
        $newM = intdiv($m + 1, 2);
        $groups = [];
        for ($p = 1; $p <= intdiv($m, 2); $p++) {
            $q = $m + 1 - $p;
            if ($f == $p || $f == $q) $groups[] = [$f];
            elseif ($s == $p || $s == $q) $groups[] = [$s];
            else $groups[] = [$p, $q];
        }
        if ($m % 2 == 1) $groups[] = [intdiv($m + 1, 2)];
        $combos = [[]];
        foreach ($groups as $g) {
            $next = [];
            foreach ($combos as $c) foreach ($g as $x) { $cc = $c; $cc[] = $x; $next[] = $cc; }
            $combos = $next;
        }
        $outcomes = [];
        foreach ($combos as $combo) {
            $bf = 0; $bs = 0;
            foreach ($combo as $w) { if ($w < $f) $bf++; if ($w < $s) $bs++; }
            $outcomes[($bf + 1) * 100 + ($bs + 1)] = [$bf + 1, $bs + 1];
        }
        $earliest = PHP_INT_MAX; $latest = -PHP_INT_MAX;
        foreach ($outcomes as $o) {
            $r = $this->dp($newM, $o[0], $o[1]);
            $earliest = min($earliest, $r[0] + 1);
            $latest = max($latest, $r[1] + 1);
        }
        $res = [$earliest, $latest];
        $this->memo[$key] = $res;
        return $res;
    }
}
