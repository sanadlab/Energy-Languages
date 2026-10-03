class Solution {
    fun minDays(n: Int): Int {
        val memo = HashMap<Int, Int>()
        fun solve(x: Int): Int {
            if (x <= 1) return x
            memo[x]?.let { return it }
            val res = 1 + minOf(x % 2 + solve(x / 2), x % 3 + solve(x / 3))
            memo[x] = res
            return res
        }
        return solve(n)
    }
}
