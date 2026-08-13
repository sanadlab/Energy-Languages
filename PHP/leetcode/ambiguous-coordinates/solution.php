class Solution {

    /**
     * @param String $s
     * @return String[]
     */
    function ambiguousCoordinates($s) {
        $digits = substr($s, 1, strlen($s) - 2);
        $n = strlen($digits);
        $res = [];
        for ($i = 1; $i < $n; $i++) {
            $left = $this->make(substr($digits, 0, $i));
            $right = $this->make(substr($digits, $i));
            foreach ($left as $a) {
                foreach ($right as $b) {
                    $res[] = "($a, $b)";
                }
            }
        }
        return $res;
    }

    private function make($d) {
        $out = [];
        $n = strlen($d);
        if ($n == 1) {
            $out[] = $d;
            return $out;
        }
        if ($d[0] != '0') $out[] = $d;
        for ($i = 1; $i < $n; $i++) {
            $l = substr($d, 0, $i);
            $r = substr($d, $i);
            if (($l == "0" || $l[0] != '0') && $r[strlen($r) - 1] != '0') {
                $out[] = "$l.$r";
            }
        }
        return $out;
    }
}
