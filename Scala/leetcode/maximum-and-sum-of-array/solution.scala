object Solution {
    def maximumANDSum(nums: Array[Int], numSlots: Int): Int = {
        val n = nums.length
        val full = (1 << n) - 1
        var dp = Array.fill(1 << n)(-1)
        dp(0) = 0
        var slot = 1
        while (slot <= numSlots) {
            val ndp = dp.clone()
            var mask = 0
            while (mask < (1 << n)) {
                if (dp(mask) >= 0) {
                    val base = dp(mask)
                    var i = 0
                    while (i < n) {
                        if (((mask >> i) & 1) == 0) {
                            val nm = mask | (1 << i)
                            val v = base + (nums(i) & slot)
                            if (v > ndp(nm)) ndp(nm) = v
                            var j = i + 1
                            while (j < n) {
                                if (((mask >> j) & 1) == 0) {
                                    val nm2 = nm | (1 << j)
                                    val v2 = v + (nums(j) & slot)
                                    if (v2 > ndp(nm2)) ndp(nm2) = v2
                                }
                                j += 1
                            }
                        }
                        i += 1
                    }
                }
                mask += 1
            }
            dp = ndp
            slot += 1
        }
        if (dp(full) >= 0) dp(full) else 0
    }
}
