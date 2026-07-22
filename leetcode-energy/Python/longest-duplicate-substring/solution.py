class Solution:
    def longestDupSubstring(self, s: str) -> str:
        n = len(s)

        sa = list(range(n))
        rank = [ord(c) - 97 for c in s]
        k = 1

        while k < n:
            sa.sort(key=lambda i: (rank[i], rank[i + k] if i + k < n else -1))

            new_rank = [0] * n
            for i in range(1, n):
                prev = sa[i - 1]
                curr = sa[i]
                prev_key = (rank[prev], rank[prev + k] if prev + k < n else -1)
                curr_key = (rank[curr], rank[curr + k] if curr + k < n else -1)
                new_rank[curr] = new_rank[prev] + (prev_key != curr_key)

            rank = new_rank
            if rank[sa[-1]] == n - 1:
                break
            k <<= 1

        pos = [0] * n
        for i, suffix_start in enumerate(sa):
            pos[suffix_start] = i

        best_len = 0
        best_start = 0
        h = 0

        for i in range(n):
            if pos[i] == 0:
                h = 0
                continue

            j = sa[pos[i] - 1]

            while i + h < n and j + h < n and s[i + h] == s[j + h]:
                h += 1

            if h > best_len:
                best_len = h
                best_start = i

            if h > 0:
                h -= 1

        return s[best_start:best_start + best_len]
