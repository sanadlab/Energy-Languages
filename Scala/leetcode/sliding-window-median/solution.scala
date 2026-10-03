object Solution {
    def medianSlidingWindow(nums: Array[Int], k: Int): Array[Double] = {
        val res = scala.collection.mutable.ArrayBuffer[Double]()
        val n = nums.length
        for (i <- 0 to n - k) {
            val w = nums.slice(i, i + k).sorted
            val median =
                if (k % 2 == 1) w(k / 2).toDouble
                else (w(k / 2 - 1).toLong + w(k / 2).toLong) / 2.0
            res += median
        }
        res.toArray
    }
}
