import scala.collection.mutable

object Solution {
    def minSubsequence(nums: Array[Int]): List[Int] = {
        val sorted = nums.sortWith(_ > _)
        val total = sorted.sum
        var running = 0
        val res = mutable.ArrayBuffer[Int]()
        var i = 0
        var done = false
        while (i < sorted.length && !done) {
            running += sorted(i)
            res += sorted(i)
            if (running * 2 > total) done = true
            i += 1
        }
        res.toList
    }
}
