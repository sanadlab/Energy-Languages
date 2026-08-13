class Solution:
    def nextBeautifulNumber(self, n: int) -> int:
        x = n + 1
        while True:
            cnt = [0] * 10
            t = x
            while t > 0:
                cnt[t % 10] += 1
                t //= 10
            ok = True
            for d in range(10):
                if cnt[d] != 0 and cnt[d] != d:
                    ok = False
                    break
            if ok:
                return x
            x += 1
