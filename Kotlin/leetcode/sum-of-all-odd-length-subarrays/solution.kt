class Solution {
    fun sumOddLengthSubarrays(arr: IntArray): Int {
        val n = arr.size
        var total = 0
        for (i in 0 until n) {
            val count = ((i + 1) * (n - i) + 1) / 2
            total += count * arr[i]
        }
        return total
    }
}
