from collections import Counter
from functools import lru_cache

class Solution:
    def minStickers(self, stickers: list[str], target: str) -> int:
        # Preprocess stickers into counts of letters
        sticker_counts = [Counter(s) for s in stickers]
        
        @lru_cache(None)
        def dfs(remain):
            if not remain:
                return 0
            remain_count = Counter(remain)
            # Optimization: pick a sticker that contains the first letter of remain
            first_char = remain[0]
            ans = float('inf')
            for sc in sticker_counts:
                if sc[first_char] == 0:
                    continue
                # Construct new remain after using this sticker once
                new_remain = []
                for c in remain_count:
                    diff = remain_count[c] - sc[c]
                    if diff > 0:
                        new_remain.append(c * diff)
                new_remain_str = ''.join(new_remain)
                res = dfs(new_remain_str)
                if res != -1:
                    ans = min(ans, 1 + res)
            return ans if ans != float('inf') else -1
        
        return dfs(target)
