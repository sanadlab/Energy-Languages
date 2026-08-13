class Solution {

    /**
     * @param Integer $n
     * @return Integer
     */
    function nextBeautifulNumber($n) {
        for ($x = $n + 1; ; $x++) {
            $cnt = array_fill(0, 10, 0);
            $t = $x;
            while ($t > 0) { $cnt[$t % 10]++; $t = intdiv($t, 10); }
            $ok = true;
            for ($d = 0; $d < 10; $d++) {
                if ($cnt[$d] != 0 && $cnt[$d] != $d) { $ok = false; break; }
            }
            if ($ok) return $x;
        }
    }
}
