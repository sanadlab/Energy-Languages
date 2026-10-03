object Solution {
    def shuffle(nums: Array[Int], n: Int): Array[Int] = {
        val res = new Array[Int](2 * n)
        for (i <- 0 until n) {
            res(2 * i) = nums(i)
            res(2 * i + 1) = nums(i + n)
        }
        res
    }
}
