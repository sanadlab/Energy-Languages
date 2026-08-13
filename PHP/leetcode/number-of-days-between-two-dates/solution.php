class Solution {

    /**
     * @param String $date1
     * @param String $date2
     * @return Integer
     */
    function daysBetweenDates($date1, $date2) {
        $p1 = $this->parseDate($date1);
        $p2 = $this->parseDate($date2);
        $a = $this->daysFromCivil($p1[0], $p1[1], $p1[2]);
        $b = $this->daysFromCivil($p2[0], $p2[1], $p2[2]);
        return abs($a - $b);
    }

    private function parseDate($s) {
        $parts = explode("-", (string)$s);
        $vals = array(0, 0, 0);
        $n = count($parts);
        for ($i = 0; $i < 3 && $i < $n; $i++) {
            $vals[$i] = intval($parts[$i]);
        }
        return $vals;
    }

    private function daysFromCivil($y, $m, $d) {
        $y -= ($m <= 2) ? 1 : 0;
        $era = intdiv(($y >= 0 ? $y : $y - 399), 400);
        $yoe = $y - $era * 400;
        $doy = intdiv(153 * ($m + ($m > 2 ? -3 : 9)) + 2, 5) + $d - 1;
        $doe = $yoe * 365 + intdiv($yoe, 4) - intdiv($yoe, 100) + $doy;
        return $era * 146097 + $doe - 719468;
    }
}
