object Solution {
    def maxSumTwoNoOverlap(nums: Array[Int], firstLen: Int, secondLen: Int): Int = {
        val n = nums.length
        val pre = Array.fill(n + 1)(0)
        var i = 0
        while (i < n) {
            pre(i + 1) = pre(i) + nums(i)
            i += 1
        }
        def best(l: Int, m: Int): Int = {
            var res = 0
            var maxL = 0
            var k = l + m
            while (k <= n) {
                maxL = math.max(maxL, pre(k - m) - pre(k - m - l))
                res = math.max(res, maxL + pre(k) - pre(k - m))
                k += 1
            }
            res
        }
        math.max(best(firstLen, secondLen), best(secondLen, firstLen))
    }
}
