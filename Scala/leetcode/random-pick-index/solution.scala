class Solution(_nums: Array[Int]) {

    private val rng = new scala.util.Random()

    def pick(target: Int): Int = {
        var count = 0
        var res = -1
        var i = 0
        while (i < _nums.length) {
            if (_nums(i) == target) {
                count += 1
                if (rng.nextInt(count) == 0) res = i
            }
            i += 1
        }
        res
    }

}

/**
 * Your Solution object will be instantiated and called as such:
 * val obj = new Solution(nums)
 * val param_1 = obj.pick(target)
 */
