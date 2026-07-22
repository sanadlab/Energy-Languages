class Solution:
    def nextBeautifulNumber(self, n: int) -> int:
        def balanced(x: int) -> bool:
            cnt = [0] * 10
            for ch in str(x):
                d = ord(ch) - 48
                if d == 0:
                    return False
                cnt[d] += 1
            
            for d in range(1, 10):
                if cnt[d] and cnt[d] != d:
                    return False
            return True
        
        x = n + 1
        while not balanced(x):
            x += 1
        return x
