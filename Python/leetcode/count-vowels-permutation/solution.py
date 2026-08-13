class Solution:
    def countVowelPermutation(self, n: int) -> int:
        MOD = 10**9 + 7
        
        # dp[i][j] represents the number of strings of length i ending with vowel j ('a'=0, 'e'=1, 'i'=2, 'o'=3, 'u'=4)
        dp = [[0 for _ in range(5)] for _ in range(n + 1)]
        
        # Initialize base case: there's one way to have a string of length 1 ending with each vowel
        for i in range(5):
            dp[1][i] = 1
        
        # Fill the DP table
        for i in range(2, n + 1):
            dp[i][0] = dp[i-1][1] % MOD  # 'a' can only follow 'e'
            dp[i][1] = (dp[i-1][0] + dp[i-1][2]) % MOD  # 'e' can follow 'a' or 'i'
            dp[i][2] = (dp[i-1][0] + dp[i-1][1] + dp[i-1][3] + dp[i-1][4]) % MOD  # 'i' can follow any except itself
            dp[i][3] = (dp[i-1][2] + dp[i-1][4]) % MOD  # 'o' can follow 'i' or 'u'
            dp[i][4] = dp[i-1][0] % MOD  # 'u' can only follow 'a'
        
        # Sum up all the ways to form a string of length n
        return sum(dp[n]) % MOD