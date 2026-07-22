from typing import List


class Solution:
    def findNumOfValidWords(self, words: List[str], puzzles: List[str]) -> List[int]:
        freq = {}

        for word in words:
            mask = 0
            for ch in word:
                mask |= 1 << (ord(ch) - ord('a'))
            if mask.bit_count() <= 7:
                freq[mask] = freq.get(mask, 0) + 1

        answer = []

        for puzzle in puzzles:
            first = 1 << (ord(puzzle[0]) - ord('a'))

            other = 0
            for ch in puzzle[1:]:
                other |= 1 << (ord(ch) - ord('a'))

            total = 0
            sub = other

            while True:
                total += freq.get(sub | first, 0)
                if sub == 0:
                    break
                sub = (sub - 1) & other

            answer.append(total)

        return answer
