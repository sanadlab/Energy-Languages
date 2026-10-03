class Solution {
    fun maxSumTwoNoOverlap(nums: IntArray, firstLen: Int, secondLen: Int): Int {
        val n = nums.size
        val pre = IntArray(n + 1)
        for (i in 0 until n) pre[i + 1] = pre[i] + nums[i]

        fun best(L: Int, M: Int): Int {
            var res = 0
            var maxL = 0
            for (i in L + M..n) {
                maxL = maxOf(maxL, pre[i - M] - pre[i - M - L])
                res = maxOf(res, maxL + pre[i] - pre[i - M])
            }
            return res
        }

        return maxOf(best(firstLen, secondLen), best(secondLen, firstLen))
    }
}
