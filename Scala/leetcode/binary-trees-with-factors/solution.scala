object Solution {
    def numFactoredBinaryTrees(arr: Array[Int]): Int = {
        val MOD = 1000000007L
        val sorted = arr.sorted
        val dp = scala.collection.mutable.Map[Int, Long]()
        for (i <- sorted.indices) {
            val v = sorted(i)
            var cnt = 1L
            for (j <- 0 until i) {
                val a = sorted(j)
                if (v % a == 0) {
                    val b = v / a
                    if (dp.contains(b)) {
                        cnt = (cnt + dp(a) * dp(b)) % MOD
                    }
                }
            }
            dp(v) = cnt % MOD
        }
        (dp.values.sum % MOD).toInt
    }
}
