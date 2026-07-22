from typing import List

class Solution:
    def countSmaller(self, nums: List[int]) -> List[int]:
        offset = 10001
        size = 20002
        bit = [0] * (size + 1)

        def update(i: int) -> None:
            while i <= size:
                bit[i] += 1
                i += i & -i

        def query(i: int) -> int:
            total = 0
            while i > 0:
                total += bit[i]
                i -= i & -i
            return total

        res = [0] * len(nums)

        for i in range(len(nums) - 1, -1, -1):
            idx = nums[i] + offset
            res[i] = query(idx - 1)
            update(idx)

        return res
