class Solution:
    def checkPartitioning(self, s: str) -> bool:
        n = len(s)
        pal = [bytearray(n) for _ in range(n)]

        for i in range(n - 1, -1, -1):
            pal[i][i] = 1
            for j in range(i + 1, n):
                if s[i] == s[j] and (j - i == 1 or pal[i + 1][j - 1]):
                    pal[i][j] = 1

        for i in range(1, n - 1):
            if pal[0][i - 1]:
                for j in range(i + 1, n):
                    if pal[i][j - 1] and pal[j][n - 1]:
                        return True

        return False
