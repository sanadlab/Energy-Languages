class Solution {
    fun kidsWithCandies(candies: IntArray, extraCandies: Int): List<Boolean> {
        val maxCandies = candies.max()
        return candies.map { it + extraCandies >= maxCandies }
    }
}
