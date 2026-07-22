class Solution:
    def minCut(self, s: str) -> int:
        n = len(s)
        cuts = list(range(n))

        for center in range(n):
            l = r = center
            while l >= 0 and r < n and s[l] == s[r]:
                cuts[r] = 0 if l == 0 else min(cuts[r], cuts[l - 1] + 1)
                l -= 1
                r += 1

            l, r = center, center + 1
            while l >= 0 and r < n and s[l] == s[r]:
                cuts[r] = 0 if l == 0 else min(cuts[r], cuts[l - 1] + 1)
                l -= 1
                r += 1

        return cuts[-1]
