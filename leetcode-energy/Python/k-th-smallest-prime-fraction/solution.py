from typing import List

class Solution:
    def kthSmallestPrimeFraction(self, arr: List[int], k: int) -> List[int]:
        n = len(arr)
        left, right = 0.0, 1.0
        ans_num, ans_den = 0, 1

        for _ in range(60):
            mid = (left + right) / 2.0
            count = 0
            i = 0
            best_num, best_den = 0, 1

            for j in range(1, n):
                while i < j and arr[i] <= mid * arr[j]:
                    i += 1

                count += i

                if i > 0:
                    num, den = arr[i - 1], arr[j]
                    if best_num * den < num * best_den:
                        best_num, best_den = num, den

            if count < k:
                left = mid
            else:
                right = mid
                ans_num, ans_den = best_num, best_den

        return [ans_num, ans_den]
