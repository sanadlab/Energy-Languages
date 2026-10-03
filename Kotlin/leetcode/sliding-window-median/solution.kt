class Solution {
    fun medianSlidingWindow(nums: IntArray, k: Int): DoubleArray {
        val n = nums.size
        val res = DoubleArray(n - k + 1)
        for (i in 0..n - k) {
            val w = nums.copyOfRange(i, i + k)
            w.sort()
            val median: Double = if (k % 2 == 1) {
                w[k / 2].toDouble()
            } else {
                (w[k / 2 - 1].toDouble() + w[k / 2].toDouble()) / 2.0
            }
            res[i] = median
        }
        return res
    }
}
