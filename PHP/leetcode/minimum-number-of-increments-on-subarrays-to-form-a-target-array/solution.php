class Solution {
    function minNumberOperations($target) {
        if (count($target) === 0) return 0;
        $ans = $target[0];
        $n = count($target);
        for ($i = 1; $i < $n; $i++) {
            if ($target[$i] > $target[$i-1]) $ans += $target[$i] - $target[$i-1];
        }
        return $ans;
    }
}
