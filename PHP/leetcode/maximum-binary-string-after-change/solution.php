class Solution {
    function maximumBinaryString($binary) {
        $n = strlen($binary);
        $first = -1; $zeros = 0;
        for ($i = 0; $i < $n; $i++) {
            if ($binary[$i] === '0') { if ($first === -1) $first = $i; $zeros++; }
        }
        if ($first === -1) return $binary;
        $res = str_repeat('1', $n);
        $res[$first + $zeros - 1] = '0';
        return $res;
    }
}
