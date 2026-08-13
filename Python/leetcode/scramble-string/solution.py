class Solution:
    def isScramble(self, s1: str, s2: str) -> bool:
        if len(s1) != len(s2):
            return False
        n = len(s1)
        dp = [[[False for _ in range(n)] for _ in range(n)] for _ in range(n + 1)]
        
        # Check if two substrings are equal
        def check_equal(i1, i2, length):
            return sorted(s1[i1:i1 + length]) == sorted(s2[i2:i2 + length])
        
        # Fill the dp table
        for length in range(1, n + 1):
            for i in range(n - length + 1):
                for j in range(n - length + 1):
                    if check_equal(i, j, length) and length == 1:
                        dp[length][i][j] = True
                    elif check_equal(i, j, length):
                        for k in range(1, length):
                            if (dp[k][i][j] and dp[length - k][i + k][j + k]) or \
                               (dp[k][i][j + length - k] and dp[length - k][i + k][j]):
                                dp[length][i][j] = True
                                break
        
        return dp[n][0][0]