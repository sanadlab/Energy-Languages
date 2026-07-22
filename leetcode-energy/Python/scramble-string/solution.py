from functools import lru_cache

class Solution:
    def isScramble(self, s1: str, s2: str) -> bool:
        n = len(s1)
        
        if s1 == s2:
            return True
        
        pref1 = [[0] * 26 for _ in range(n + 1)]
        pref2 = [[0] * 26 for _ in range(n + 1)]
        
        for i in range(n):
            pref1[i + 1] = pref1[i][:]
            pref2[i + 1] = pref2[i][:]
            pref1[i + 1][ord(s1[i]) - ord('a')] += 1
            pref2[i + 1][ord(s2[i]) - ord('a')] += 1
        
        def same_chars(i: int, j: int, length: int) -> bool:
            for c in range(26):
                if pref1[i + length][c] - pref1[i][c] != pref2[j + length][c] - pref2[j][c]:
                    return False
            return True
        
        @lru_cache(None)
        def dfs(i: int, j: int, length: int) -> bool:
            if s1[i:i + length] == s2[j:j + length]:
                return True
            
            if not same_chars(i, j, length):
                return False
            
            for split in range(1, length):
                if dfs(i, j, split) and dfs(i + split, j + split, length - split):
                    return True
                
                if dfs(i, j + length - split, split) and dfs(i + split, j, length - split):
                    return True
            
            return False
        
        return dfs(0, 0, n)
