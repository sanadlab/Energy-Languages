object Solution {
    def nextGreaterElements(nums: Array[Int]): Array[Int] = {
        val n = nums.length
        val res = Array.fill(n)(-1)
        val st = scala.collection.mutable.ArrayBuffer[Int]()
        for (i <- 0 until 2 * n) {
            val cur = nums(i % n)
            while (st.nonEmpty && nums(st.last) < cur) {
                val idx = st.remove(st.length - 1)
                res(idx) = cur
            }
            if (i < n) st += i
        }
        res
    }
}
