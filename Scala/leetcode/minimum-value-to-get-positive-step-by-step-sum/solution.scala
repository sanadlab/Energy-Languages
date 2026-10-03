object Solution {
    def minStartValue(nums: Array[Int]): Int = {
        var prefix = 0
        var minPrefix = 0
        for (x <- nums) {
            prefix += x
            if (prefix < minPrefix) minPrefix = prefix
        }
        math.max(1, 1 - minPrefix)
    }
}
