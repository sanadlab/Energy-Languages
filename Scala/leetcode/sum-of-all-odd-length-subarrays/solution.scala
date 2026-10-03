object Solution {
    def sumOddLengthSubarrays(arr: Array[Int]): Int = {
        val n = arr.length
        var total = 0
        for (i <- 0 until n) {
            val count = ((i + 1) * (n - i) + 1) / 2
            total += count * arr(i)
        }
        total
    }
}
