from functools import lru_cache
from collections import defaultdict

class Solution:
    def getLengthOfOptimalCompression(self, s: str, k: int) -> int:
        n = len(s)

        def enc_len(cnt: int) -> int:
            if cnt == 1:
                return 1
            if cnt < 10:
                return 2
            if cnt < 100:
                return 3
            return 4

        @lru_cache(None)
        def dp(i: int, deletes_left: int) -> int:
            if deletes_left < 0:
                return float("inf")
            if i >= n or n - i <= deletes_left:
                return 0

            res = float("inf")
            counts = defaultdict(int)
            max_freq = 0

            for j in range(i, n):
                counts[s[j]] += 1
                max_freq = max(max_freq, counts[s[j]])

                deletions_needed = (j - i + 1) - max_freq
                if deletions_needed <= deletes_left:
                    res = min(
                        res,
                        enc_len(max_freq) + dp(j + 1, deletes_left - deletions_needed)
                    )

            return res

        return dp(0, k)
