class Solution {
    function sortByBits($arr) {
        usort($arr, function($a, $b) {
            $pa = substr_count(decbin($a), '1');
            $pb = substr_count(decbin($b), '1');
            if ($pa != $pb) return $pa - $pb;
            return $a - $b;
        });
        return $arr;
    }
}
