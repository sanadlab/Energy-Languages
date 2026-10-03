object Solution {
    def maxEqualFreq(nums: Array[Int]): Int = {
        val n = nums.length
        val count = new Array[Int](100001)
        val freq = new Array[Int](n + 1)
        var maxF = 0
        var res = 0
        var i = 0
        while (i < n) {
            val v = nums(i)
            if (count(v) > 0) freq(count(v)) -= 1
            count(v) += 1
            freq(count(v)) += 1
            if (count(v) > maxF) maxF = count(v)
            if (maxF == 1
                    || freq(maxF) * maxF == i
                    || (freq(maxF) == 1 && (maxF - 1) * (freq(maxF - 1) + 1) == i)) {
                res = i + 1
            }
            i += 1
        }
        res
    }
}
