class Solution:
    def minStickers(self, stickers, target):
        n = len(target)
        full = (1 << n) - 1
        INF = float('inf')
        dp = [INF] * (1 << n)
        dp[0] = 0
        cnt = []
        for s in stickers:
            c = [0] * 26
            for ch in s:
                c[ord(ch) - 97] += 1
            cnt.append(c)
        for state in range(1 << n):
            if dp[state] == INF:
                continue
            for c in cnt:
                avail = c[:]
                nxt = state
                for i in range(n):
                    if not (state & (1 << i)):
                        idx = ord(target[i]) - 97
                        if avail[idx] > 0:
                            avail[idx] -= 1
                            nxt |= (1 << i)
                if dp[state] + 1 < dp[nxt]:
                    dp[nxt] = dp[state] + 1
        return -1 if dp[full] == INF else dp[full]
