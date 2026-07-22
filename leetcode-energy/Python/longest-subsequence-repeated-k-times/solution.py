from collections import Counter, deque

class Solution:
    def longestSubsequenceRepeatedK(self, s: str, k: int) -> str:
        freq = Counter(s)
        caps = {ch: cnt // k for ch, cnt in freq.items() if cnt >= k}
        chars = sorted(caps)
        max_len = len(s) // k

        def valid(seq: str) -> bool:
            i = 0
            completed = 0
            m = len(seq)

            for ch in s:
                if ch == seq[i]:
                    i += 1
                    if i == m:
                        completed += 1
                        if completed == k:
                            return True
                        i = 0

            return False

        ans = ""
        q = deque([""])

        while q:
            cur = q.popleft()

            if len(cur) == max_len:
                continue

            for ch in chars:
                if cur.count(ch) >= caps[ch]:
                    continue

                nxt = cur + ch

                if valid(nxt):
                    if len(nxt) > len(ans) or (len(nxt) == len(ans) and nxt > ans):
                        ans = nxt
                    q.append(nxt)

        return ans
