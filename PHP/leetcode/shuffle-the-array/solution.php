class Solution {
    function shuffle($nums, $n) {
        $m = intdiv(count($nums), 2);
        $res = array();
        for ($i = 0; $i < $m; $i++) {
            $res[] = $nums[$i];
            $res[] = $nums[$i + $m];
        }
        return $res;
    }
}
