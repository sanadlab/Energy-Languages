from typing import List

class Solution:
    def palindromePairs(self, words: List[str]) -> List[List[int]]:
        word_to_index = {word: i for i, word in enumerate(words)}

        def palindrome_flags(s: str):
            n = len(s)
            d1 = [0] * n
            l, r = 0, -1
            for i in range(n):
                k = 1 if i > r else min(d1[l + r - i], r - i + 1)
                while i - k >= 0 and i + k < n and s[i - k] == s[i + k]:
                    k += 1
                d1[i] = k
                if i + k - 1 > r:
                    l, r = i - k + 1, i + k - 1

            d2 = [0] * n
            l, r = 0, -1
            for i in range(n):
                k = 0 if i > r else min(d2[l + r - i + 1], r - i + 1)
                while i - k - 1 >= 0 and i + k < n and s[i - k - 1] == s[i + k]:
                    k += 1
                d2[i] = k
                if i + k - 1 > r:
                    l, r = i - k, i + k - 1

            def is_pal(left: int, right: int) -> bool:
                length = right - left
                if length <= 1:
                    return True
                if length & 1:
                    center = (left + right) // 2
                    return d1[center] >= length // 2 + 1
                else:
                    center = (left + right) // 2
                    return d2[center] >= length // 2

            prefix = [False] * (n + 1)
            suffix = [False] * (n + 1)

            for cut in range(n + 1):
                prefix[cut] = is_pal(0, cut)
                suffix[cut] = is_pal(cut, n)

            return prefix, suffix

        ans = []

        for i, word in enumerate(words):
            n = len(word)
            rev = word[::-1]
            prefix_pal, suffix_pal = palindrome_flags(word)

            for cut in range(n + 1):
                if prefix_pal[cut]:
                    j = word_to_index.get(rev[:n - cut], -1)
                    if j != -1 and j != i:
                        ans.append([j, i])

                if cut < n and suffix_pal[cut]:
                    j = word_to_index.get(rev[n - cut:], -1)
                    if j != -1 and j != i:
                        ans.append([i, j])

        return ans
