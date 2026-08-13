class Solution {
    private $mod = 1000000007;
    private $C;

    /**
     * @param Integer[] $nums
     * @return Integer
     */
    function numOfWays($nums) {
        $n = count($nums);
        $this->C = array();
        for ($i = 0; $i <= $n; $i++) {
            $this->C[$i] = array_fill(0, $n + 1, 0);
            $this->C[$i][0] = 1;
            for ($j = 1; $j <= $i; $j++)
                $this->C[$i][$j] = ($this->C[$i - 1][$j - 1] + $this->C[$i - 1][$j]) % $this->mod;
        }
        return (int)((($this->ways($nums) - 1) % $this->mod + $this->mod) % $this->mod);
    }

    private function ways($arr) {
        $m = count($arr);
        if ($m <= 2) return 1;
        $root = $arr[0];
        $left = array();
        $right = array();
        for ($i = 1; $i < $m; $i++) {
            if ($arr[$i] < $root) $left[] = $arr[$i];
            else $right[] = $arr[$i];
        }
        return $this->C[$m - 1][count($left)] * $this->ways($left) % $this->mod * $this->ways($right) % $this->mod;
    }
}
