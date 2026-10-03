object Solution {
    def lengthOfLIS(nums: Array[Int]): Int = {
        val tails = scala.collection.mutable.ArrayBuffer[Int]()
        for (x <- nums) {
            var lo = 0
            var hi = tails.length
            while (lo < hi) {
                val mid = (lo + hi) / 2
                if (tails(mid) < x) lo = mid + 1 else hi = mid
            }
            if (lo == tails.length) tails += x
            else tails(lo) = x
        }
        tails.length
    }
}
