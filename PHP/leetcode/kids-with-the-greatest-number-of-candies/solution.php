class Solution {
    function kidsWithCandies($candies, $extraCandies) {
        $mx = max($candies);
        $res = [];
        foreach ($candies as $c) {
            $res[] = ($c + $extraCandies) >= $mx;
        }
        return $res;
    }
}
