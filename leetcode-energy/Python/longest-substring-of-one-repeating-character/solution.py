from typing import List

class Solution:
    def longestRepeating(self, s: str, queryCharacters: str, queryIndices: List[int]) -> List[int]:
        n = len(s)

        def merge(a, b):
            if a[5] == 0:
                return b
            if b[5] == 0:
                return a

            left_char = a[0]
            right_char = b[1]
            length = a[5] + b[5]

            pref = a[2]
            if a[2] == a[5] and a[1] == b[0]:
                pref = a[5] + b[2]

            suff = b[3]
            if b[3] == b[5] and a[1] == b[0]:
                suff = b[5] + a[3]

            best = max(a[4], b[4])
            if a[1] == b[0]:
                best = max(best, a[3] + b[2])

            return (left_char, right_char, pref, suff, best, length)

        size = 1
        while size < n:
            size <<= 1

        empty = ("", "", 0, 0, 0, 0)
        tree = [empty] * (2 * size)

        for i, ch in enumerate(s):
            tree[size + i] = (ch, ch, 1, 1, 1, 1)

        for i in range(size - 1, 0, -1):
            tree[i] = merge(tree[i << 1], tree[i << 1 | 1])

        ans = []

        for idx, ch in zip(queryIndices, queryCharacters):
            pos = size + idx
            tree[pos] = (ch, ch, 1, 1, 1, 1)
            pos >>= 1

            while pos:
                tree[pos] = merge(tree[pos << 1], tree[pos << 1 | 1])
                pos >>= 1

            ans.append(tree[1][4])

        return ans
