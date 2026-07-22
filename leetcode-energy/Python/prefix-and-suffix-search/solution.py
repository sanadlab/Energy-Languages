from typing import List

class WordFilter:
    def __init__(self, words: List[str]):
        self.base = 27 ** 7
        self.lookup = {}
        base = self.base
        lookup = self.lookup

        for idx, word in enumerate(words):
            prefix_codes = [0]
            code = 0
            for ch in word:
                code = code * 27 + ord(ch) - 96
                prefix_codes.append(code)

            suffix_codes = [0]
            n = len(word)
            for i in range(n):
                code = 0
                for ch in word[i:]:
                    code = code * 27 + ord(ch) - 96
                suffix_codes.append(code)

            for p in prefix_codes:
                offset = p * base
                for s in suffix_codes:
                    lookup[offset + s] = idx

    def f(self, pref: str, suff: str) -> int:
        p = 0
        for ch in pref:
            p = p * 27 + ord(ch) - 96

        s = 0
        for ch in suff:
            s = s * 27 + ord(ch) - 96

        return self.lookup.get(p * self.base + s, -1)
