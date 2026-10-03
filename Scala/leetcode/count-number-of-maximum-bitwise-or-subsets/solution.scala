object Solution {
    def countMaxOrSubsets(nums: Array[Int]): Int = {
        var maxOr = 0
        for (num <- nums) maxOr |= num
        val n = nums.length
        var count = 0
        var mask = 1
        while (mask < (1 << n)) {
            var cur = 0
            var i = 0
            while (i < n) {
                if ((mask & (1 << i)) != 0) cur |= nums(i)
                i += 1
            }
            if (cur == maxOr) count += 1
            mask += 1
        }
        count
    }
}
