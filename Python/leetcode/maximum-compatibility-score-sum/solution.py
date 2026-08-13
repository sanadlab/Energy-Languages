class Solution:
    def maxCompatibilitySum(self, students, mentors):
        m = len(students)
        n = len(students[0]) if m else 0
        score = [[0] * m for _ in range(m)]
        for i in range(m):
            for j in range(m):
                score[i][j] = sum(1 for k in range(n) if students[i][k] == mentors[j][k])
        dp = [0] * (1 << m)
        for mask in range(1 << m):
            i = bin(mask).count('1')
            if i >= m:
                continue
            for j in range(m):
                if (mask >> j) & 1:
                    continue
                nm = mask | (1 << j)
                val = dp[mask] + score[i][j]
                if val > dp[nm]:
                    dp[nm] = val
        return dp[(1 << m) - 1]
