from functools import lru_cache
from typing import List


class Solution:
    def earliestAndLatest(self, n: int, firstPlayer: int, secondPlayer: int) -> List[int]:
        @lru_cache(None)
        def dp(m: int, a: int, b: int):
            if a + b == m + 1:
                return (1, 1)

            states = {(0, 0)}

            def apply_choices(cur_states, choices):
                deltas = set()
                for w in choices:
                    deltas.add((1 if w < a else 0, 1 if w < b else 0))

                nxt = set()
                for ca, cb in cur_states:
                    for da, db in deltas:
                        nxt.add((ca + da, cb + db))
                return nxt

            for i in range(1, m // 2 + 1):
                l, r = i, m + 1 - i

                if l == a or r == a:
                    choices = [a]
                elif l == b or r == b:
                    choices = [b]
                else:
                    choices = [l, r]

                states = apply_choices(states, choices)

            if m % 2 == 1:
                mid = m // 2 + 1
                states = apply_choices(states, [mid])

            next_m = (m + 1) // 2
            earliest = float("inf")
            latest = 0

            for ca, cb in states:
                na, nb = ca + 1, cb + 1
                e, l = dp(next_m, na, nb)
                earliest = min(earliest, e + 1)
                latest = max(latest, l + 1)

            return (earliest, latest)

        return list(dp(n, firstPlayer, secondPlayer))
