object Solution {
    def findKDistantIndices(nums: Array[Int], key: Int, k: Int): List[Int] = {
        val n = nums.length
        val result = scala.collection.mutable.ListBuffer[Int]()
        for (i <- 0 until n) {
            var found = false
            var j = 0
            while (j < n && !found) {
                if (math.abs(i - j) <= k && nums(j) == key) found = true
                j += 1
            }
            if (found) result += i
        }
        result.toList
    }
}
