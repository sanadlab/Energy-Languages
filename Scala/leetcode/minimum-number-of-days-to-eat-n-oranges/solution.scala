object Solution {
    def minDays(n: Int): Int = {
        val memo = scala.collection.mutable.HashMap[Int, Int]()
        def solve(x: Int): Int = {
            if (x <= 1) x
            else memo.getOrElseUpdate(x, {
                1 + math.min(x % 2 + solve(x / 2), x % 3 + solve(x / 3))
            })
        }
        solve(n)
    }
}
