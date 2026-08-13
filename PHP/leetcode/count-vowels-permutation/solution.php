class Solution {
    /**
     * @param Integer $n
     * @return Integer
     */
    function countVowelPermutation($n) {
        $mod = 1000000007;
        // dp arrays to hold counts for each vowel at position i
        // Indexes: 0->a, 1->e, 2->i, 3->o, 4->u
        $dp = array_fill(0, 5, 1);

        for ($i = 2; $i <= $n; $i++) {
            $a = ($dp[1]) % $mod; // 'a' can only follow 'e'
            $e = ($dp[0] + $dp[2]) % $mod; // 'e' can follow 'a' or 'i'
            $i_ = ($dp[0] + $dp[1] + $dp[3] + $dp[4]) % $mod; // 'i' can follow all except 'i'
            $o = ($dp[2] + $dp[4]) % $mod; // 'o' can follow 'i' or 'u'
            $u = ($dp[0]) % $mod; // 'u' can follow 'a'

            $dp = [$a, $e, $i_, $o, $u];
        }

        $result = 0;
        foreach ($dp as $count) {
            $result = ($result + $count) % $mod;
        }
        return $result;
    }
}