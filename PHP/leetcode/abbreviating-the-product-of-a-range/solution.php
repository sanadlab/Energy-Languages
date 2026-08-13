class Solution {

    /**
     * @param Integer $left
     * @param Integer $right
     * @return String
     */
    function abbreviateProduct($left, $right) {
        $SUFMOD = 10000000000000; // 1e13
        $suf = 1;
        $pre = 1.0;
        $c2 = 0; $c5 = 0;
        $extra = 0;
        for ($i = $left; $i <= $right; $i++) {
            $x = $i;
            while ($x % 2 == 0) { $x = intdiv($x, 2); $c2++; }
            while ($x % 5 == 0) { $x = intdiv($x, 5); $c5++; }
            $suf = ($suf * $x) % $SUFMOD;
            $pre *= $i;
            while ($pre >= 1e15) { $pre /= 10; $extra++; }
        }
        $C = min($c2, $c5);
        $r2 = $c2 - $C; $r5 = $c5 - $C;
        for ($k = 0; $k < $r2; $k++) $suf = ($suf * 2) % $SUFMOD;
        for ($k = 0; $k < $r5; $k++) $suf = ($suf * 5) % $SUFMOD;
        $tmp = $pre; $intdigits = 1;
        while ($tmp >= 10) { $tmp /= 10; $intdigits++; }
        $Nfull = $extra + $intdigits;
        $d = $Nfull - $C;
        if ($d <= 10) {
            return strval($suf) . "e" . strval($C);
        }
        $lead = $pre;
        while ($lead >= 100000) $lead /= 10;
        while ($lead < 10000) $lead *= 10;
        $first5 = (int)$lead;
        $last5 = $suf % 100000;
        return strval($first5) . "..." . str_pad(strval($last5), 5, "0", STR_PAD_LEFT) . "e" . strval($C);
    }
}
