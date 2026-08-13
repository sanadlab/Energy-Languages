class Solution {
    private $nums;

    /**
     * @param Integer[] $nums
     */
    function __construct($nums = array()) {
        $this->nums = $nums;
    }

    /**
     * @param Integer $target
     * @return Integer
     */
    function pick($target) {
        $count = 0;
        $res = -1;
        foreach ($this->nums as $i => $x) {
            if ($x == $target) {
                $count++;
                if (mt_rand(1, $count) === 1) {
                    $res = $i;
                }
            }
        }
        return $res;
    }
}
