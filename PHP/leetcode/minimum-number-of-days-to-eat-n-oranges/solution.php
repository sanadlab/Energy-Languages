class Solution {
    private $memo = array();
    function minDays($n) {
        if ($n <= 1) return $n;
        if (isset($this->memo[$n])) return $this->memo[$n];
        $res = 1 + min($n % 2 + $this->minDays(intdiv($n, 2)), $n % 3 + $this->minDays(intdiv($n, 3)));
        $this->memo[$n] = $res;
        return $res;
    }
}
