import random


class Solution:
    def __init__(self, nums=None):
        self.nums = nums if nums is not None else []

    def pick(self, target):
        # Reservoir sampling: pick a uniformly random index among all
        # positions whose value equals target, using O(1) extra space.
        count = 0
        res = -1
        for i, x in enumerate(self.nums):
            if x == target:
                count += 1
                if random.randint(1, count) == 1:
                    res = i
        return res
