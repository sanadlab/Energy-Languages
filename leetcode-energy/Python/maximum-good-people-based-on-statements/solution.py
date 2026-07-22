from typing import List

class Solution:
    def maximumGood(self, statements: List[List[int]]) -> int:
        n = len(statements)
        good_req = [0] * n
        bad_req = [0] * n

        for i in range(n):
            for j in range(n):
                if statements[i][j] == 1:
                    good_req[i] |= 1 << j
                elif statements[i][j] == 0:
                    bad_req[i] |= 1 << j

        ans = 0

        for mask in range(1 << n):
            valid = True

            for i in range(n):
                if mask & (1 << i):
                    if (mask & good_req[i]) != good_req[i] or (mask & bad_req[i]) != 0:
                        valid = False
                        break

            if valid:
                ans = max(ans, mask.bit_count())

        return ans
