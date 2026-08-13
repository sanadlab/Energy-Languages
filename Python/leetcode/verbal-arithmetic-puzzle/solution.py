from typing import *


class Solution:
    def isSolvable(self, words: List[str], result: str) -> bool:
        max_len = len(result)
        for w in words:
            if len(w) > max_len:
                return False
        assigned = {}
        used = [False] * 10
        leading = set()
        for w in words:
            if len(w) > 1:
                leading.add(w[0])
        if len(result) > 1:
            leading.add(result[0])

        def solve(col, row, carry):
            if col == max_len:
                return carry == 0
            if row < len(words):
                w = words[row]
                if col >= len(w):
                    return solve(col, row + 1, carry)
                ch = w[len(w) - 1 - col]
                if ch in assigned:
                    return solve(col, row + 1, carry)
                for d in range(10):
                    if not used[d] and not (d == 0 and ch in leading):
                        used[d] = True
                        assigned[ch] = d
                        if solve(col, row + 1, carry):
                            return True
                        used[d] = False
                        del assigned[ch]
                return False
            s = carry
            for w in words:
                if col < len(w):
                    s += assigned[w[len(w) - 1 - col]]
            digit = s % 10
            new_carry = s // 10
            rch = result[max_len - 1 - col]
            if rch in assigned:
                if assigned[rch] == digit:
                    return solve(col + 1, 0, new_carry)
                return False
            if used[digit]:
                return False
            if digit == 0 and rch in leading:
                return False
            used[digit] = True
            assigned[rch] = digit
            if solve(col + 1, 0, new_carry):
                return True
            used[digit] = False
            del assigned[rch]
            return False

        return solve(0, 0, 0)
