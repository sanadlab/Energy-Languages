class Solution {
    function sumOddLengthSubarrays($arr) {
        $n = count($arr);
        $total = 0;
        for ($i = 0; $i < $n; $i++) {
            $count = intdiv(($i + 1) * ($n - $i) + 1, 2);
            $total += $count * $arr[$i];
        }
        return $total;
    }
}
