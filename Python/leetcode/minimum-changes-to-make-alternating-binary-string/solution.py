class Solution:
    def minOperations(self, s: str) -> int:
        cnt = 0
        n = len(s)
        for i in range(n):
            expected = '0' if i % 2 == 0 else '1'
            if s[i] != expected:
                cnt += 1
        return min(cnt, n - cnt)
