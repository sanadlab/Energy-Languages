class Solution {
    fun maxEqualFreq(nums: IntArray): Int {
        val n = nums.size
        val count = IntArray(100001)
        val freq = IntArray(n + 1)
        var maxF = 0
        var res = 0
        for (i in 0 until n) {
            val v = nums[i]
            if (count[v] > 0) freq[count[v]] -= 1
            count[v] += 1
            freq[count[v]] += 1
            if (count[v] > maxF) maxF = count[v]
            if (maxF == 1 ||
                freq[maxF] * maxF == i ||
                (freq[maxF] == 1 && (maxF - 1) * (freq[maxF - 1] + 1) == i)
            ) {
                res = i + 1
            }
        }
        return res
    }
}
