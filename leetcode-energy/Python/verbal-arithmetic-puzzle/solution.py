from typing import List

class Solution:
    def isSolvable(self, words: List[str], result: str) -> bool:
        unique = set("".join(words) + result)
        if len(unique) > 10:
            return False

        max_word_len = max(len(w) for w in words)
        if len(result) < max_word_len or len(result) > max_word_len + 1:
            return False

        char_id = {ch: i for i, ch in enumerate(unique)}
        k = len(unique)

        nonzero = [False] * k
        for w in words + [result]:
            if len(w) > 1:
                nonzero[char_id[w[0]]] = True

        rev_words = [[char_id[ch] for ch in reversed(w)] for w in words]
        rev_result = [char_id[ch] for ch in reversed(result)]

        assigned = [-1] * k
        n = len(words)
        L = len(result)

        def dfs(col: int, row: int, total: int, used_mask: int) -> bool:
            if col == L:
                return total == 0

            if row < n:
                if col >= len(rev_words[row]):
                    return dfs(col, row + 1, total, used_mask)

                ch = rev_words[row][col]
                if assigned[ch] != -1:
                    return dfs(col, row + 1, total + assigned[ch], used_mask)

                for d in range(10):
                    if used_mask & (1 << d):
                        continue
                    if d == 0 and nonzero[ch]:
                        continue

                    assigned[ch] = d
                    if dfs(col, row + 1, total + d, used_mask | (1 << d)):
                        return True
                    assigned[ch] = -1

                return False

            ch = rev_result[col]
            need = total % 10
            carry = total // 10

            if assigned[ch] != -1:
                if assigned[ch] != need:
                    return False
                return dfs(col + 1, 0, carry, used_mask)

            if used_mask & (1 << need):
                return False
            if need == 0 and nonzero[ch]:
                return False

            assigned[ch] = need
            if dfs(col + 1, 0, carry, used_mask | (1 << need)):
                return True
            assigned[ch] = -1

            return False

        return dfs(0, 0, 0, 0)
