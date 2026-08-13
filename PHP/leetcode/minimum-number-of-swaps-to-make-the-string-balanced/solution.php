class Solution {
    function minSwaps($s) {
        $open = 0;
        $len = strlen($s);
        for ($i = 0; $i < $len; $i++) {
            $c = $s[$i];
            if ($c === '[') $open++;
            else if ($open > 0) $open--;
        }
        return intdiv($open + 1, 2);
    }
}
