class Solution:
    def maxEqualFreq(self, nums):
        n = len(nums)
        count = [0] * 100001
        freq = [0] * (n + 1)
        maxF = 0
        res = 0
        for i in range(n):
            v = nums[i]
            if count[v] > 0:
                freq[count[v]] -= 1
            count[v] += 1
            freq[count[v]] += 1
            if count[v] > maxF:
                maxF = count[v]
            if (maxF == 1
                    or freq[maxF] * maxF == i
                    or (freq[maxF] == 1 and (maxF - 1) * (freq[maxF - 1] + 1) == i)):
                res = i + 1
        return res
