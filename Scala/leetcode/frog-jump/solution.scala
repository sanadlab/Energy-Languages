object Solution {
    def canCross(stones: Array[Int]): Boolean = {
        if (stones.length < 2) return false
        if (stones(1) != 1) return false
        val stoneSet = stones.toSet
        val dp = scala.collection.mutable.Map[Int, scala.collection.mutable.Set[Int]]()
        for (stone <- stones) dp(stone) = scala.collection.mutable.Set[Int]()
        dp(1) += 1
        for (stone <- stones) {
            for (k <- dp(stone).toList) {
                for (step <- List(k - 1, k, k + 1)) {
                    if (step > 0 && stoneSet.contains(stone + step)) {
                        dp(stone + step) += step
                    }
                }
            }
        }
        dp(stones(stones.length - 1)).nonEmpty
    }
}
