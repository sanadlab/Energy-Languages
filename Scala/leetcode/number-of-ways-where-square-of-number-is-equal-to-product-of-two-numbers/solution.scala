object Solution {
    def numTriplets(nums1: Array[Int], nums2: Array[Int]): Int = {
        def helper(a: Array[Int], b: Array[Int]): Int = {
            var cnt = 0
            for (x <- a) {
                val t = x.toLong * x.toLong
                val seen = scala.collection.mutable.Map[Long, Int]()
                for (y <- b) {
                    val yl = y.toLong
                    if (t % yl == 0) {
                        val need = t / yl
                        cnt += seen.getOrElse(need, 0)
                    }
                    seen(yl) = seen.getOrElse(yl, 0) + 1
                }
            }
            cnt
        }
        helper(nums1, nums2) + helper(nums2, nums1)
    }
}
