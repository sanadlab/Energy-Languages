from functools import lru_cache
from itertools import product


class Solution:
    def earliestAndLatest(self, n: int, firstPlayer: int, secondPlayer: int) -> List[int]:
        @lru_cache(maxsize=None)
        def dp(m, f, s):
            if f > s:
                f, s = s, f
            # The two players meet this round iff they are paired together.
            if f + s == m + 1:
                return (1, 1)
            new_m = (m + 1) // 2
            groups = []
            for p in range(1, m // 2 + 1):
                q = m + 1 - p
                if f in (p, q):
                    groups.append((f,))          # firstPlayer always wins its match
                elif s in (p, q):
                    groups.append((s,))          # secondPlayer always wins its match
                else:
                    groups.append((p, q))        # either side may be chosen to win
            if m % 2 == 1:
                groups.append(((m + 1) // 2,))    # middle player auto-advances
            outcomes = set()
            for combo in product(*groups):
                below_f = sum(1 for w in combo if w < f)
                below_s = sum(1 for w in combo if w < s)
                outcomes.add((below_f + 1, below_s + 1))
            earliest = float("inf")
            latest = float("-inf")
            for nf, ns in outcomes:
                e, l = dp(new_m, nf, ns)
                earliest = min(earliest, e + 1)
                latest = max(latest, l + 1)
            return (earliest, latest)

        earliest, latest = dp(n, firstPlayer, secondPlayer)
        return [earliest, latest]
