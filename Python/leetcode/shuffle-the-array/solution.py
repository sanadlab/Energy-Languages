class Solution:
    def shuffle(self, nums, n):
        m = len(nums) // 2
        res = []
        for i in range(m):
            res.append(nums[i])
            res.append(nums[i + m])
        return res
