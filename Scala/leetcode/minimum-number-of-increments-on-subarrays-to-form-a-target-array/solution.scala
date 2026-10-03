object Solution {
    def minNumberOperations(target: Array[Int]): Int = {
        if (target.isEmpty) 0
        else {
            var ans = target(0)
            for (i <- 1 until target.length) {
                if (target(i) > target(i - 1)) ans += target(i) - target(i - 1)
            }
            ans
        }
    }
}
