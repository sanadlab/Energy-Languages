from typing import List

class Solution:
    def shortestSuperstring(self, words: List[str]) -> str:
        n = len(words)

        overlap = [[0] * n for _ in range(n)]
        for i in range(n):
            for j in range(n):
                if i == j:
                    continue
                max_len = min(len(words[i]), len(words[j]))
                for k in range(max_len, -1, -1):
                    if words[i].endswith(words[j][:k]):
                        overlap[i][j] = k
                        break

        size = 1 << n
        dp = [[-1] * n for _ in range(size)]
        parent = [[-1] * n for _ in range(size)]

        for i in range(n):
            dp[1 << i][i] = 0

        for mask in range(size):
            for last in range(n):
                if dp[mask][last] == -1:
                    continue

                for nxt in range(n):
                    if mask & (1 << nxt):
                        continue

                    new_mask = mask | (1 << nxt)
                    new_overlap = dp[mask][last] + overlap[last][nxt]

                    if new_overlap > dp[new_mask][nxt]:
                        dp[new_mask][nxt] = new_overlap
                        parent[new_mask][nxt] = last

        full_mask = size - 1
        last = max(range(n), key=lambda i: dp[full_mask][i])

        order = []
        mask = full_mask

        while last != -1:
            order.append(last)
            prev = parent[mask][last]
            mask ^= 1 << last
            last = prev

        order.reverse()

        result = words[order[0]]
        for i in range(1, n):
            prev_word = order[i - 1]
            curr_word = order[i]
            result += words[curr_word][overlap[prev_word][curr_word]:]

        return result
