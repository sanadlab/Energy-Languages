from functools import lru_cache

class Solution:
    def possiblyEquals(self, s1: str, s2: str) -> bool:
        n, m = len(s1), len(s2)

        @lru_cache(None)
        def dfs(i: int, j: int, diff: int) -> bool:
            if i == n and j == m:
                return diff == 0

            if i < n and s1[i].isdigit():
                val = 0
                for k in range(i, n):
                    if not s1[k].isdigit():
                        break
                    val = val * 10 + int(s1[k])
                    if dfs(k + 1, j, diff + val):
                        return True

            if j < m and s2[j].isdigit():
                val = 0
                for k in range(j, m):
                    if not s2[k].isdigit():
                        break
                    val = val * 10 + int(s2[k])
                    if dfs(i, k + 1, diff - val):
                        return True

            if diff == 0:
                if i < n and j < m and s1[i].isalpha() and s2[j].isalpha() and s1[i] == s2[j]:
                    return dfs(i + 1, j + 1, 0)
            elif diff > 0:
                if j < m and s2[j].isalpha():
                    return dfs(i, j + 1, diff - 1)
            else:
                if i < n and s1[i].isalpha():
                    return dfs(i + 1, j, diff + 1)

            return False

        return dfs(0, 0, 0)
