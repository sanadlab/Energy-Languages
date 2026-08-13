class Solution {

    /**
     * @param String $s
     * @param String $p
     * @return Boolean
     */
    function isMatch($s, $p) {
        $sLen = strlen($s);
        $pLen = strlen($p);

        // dp[i][j] means whether s[0..i-1] matches p[0..j-1]
        $dp = array_fill(0, $sLen + 1, array_fill(0, $pLen + 1, false));
        $dp[0][0] = true;

        // Initialize dp for patterns like *, **, ***
        for ($j = 1; $j <= $pLen; $j++) {
            if ($p[$j - 1] === '*') {
                $dp[0][$j] = $dp[0][$j - 1];
            }
        }

        for ($i = 1; $i <= $sLen; $i++) {
            for ($j = 1; $j <= $pLen; $j++) {
                if ($p[$j - 1] === '*') {
                    // '*' matches empty sequence or one more character
                    $dp[$i][$j] = $dp[$i][$j - 1] || $dp[$i - 1][$j];
                } else if ($p[$j - 1] === '?' || $p[$j - 1] === $s[$i - 1]) {
                    $dp[$i][$j] = $dp[$i - 1][$j - 1];
                } else {
                    $dp[$i][$j] = false;
                }
            }
        }

        return $dp[$sLen][$pLen];
    }
}