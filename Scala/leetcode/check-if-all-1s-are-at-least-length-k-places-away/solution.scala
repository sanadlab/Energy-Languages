object Solution {
    def kLengthApart(nums: Array[Int], k: Int): Boolean = {
        var prev = -1
        var i = 0
        var ok = true
        while (i < nums.length && ok) {
            if (nums(i) == 1) {
                if (prev != -1 && i - prev - 1 < k) ok = false
                else prev = i
            }
            i += 1
        }
        ok
    }
}
