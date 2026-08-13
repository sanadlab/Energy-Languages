class Solution {

    /**
     * @param String[] $words
     * @return Integer
     */
    function longestStrChain($words) {
        usort($words, function($a, $b) { return strlen($a) - strlen($b); });
        $dp = array();
        $best = 1;
        foreach ($words as $w) {
            $cur = 1;
            $len = strlen($w);
            for ($i = 0; $i < $len; $i++) {
                $pred = substr($w, 0, $i) . substr($w, $i + 1);
                if (isset($dp[$pred]) && $dp[$pred] + 1 > $cur) {
                    $cur = $dp[$pred] + 1;
                }
            }
            $dp[$w] = $cur;
            if ($cur > $best) $best = $cur;
        }
        return $best;
    }
}
