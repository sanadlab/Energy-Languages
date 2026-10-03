object Solution {
    def kidsWithCandies(candies: Array[Int], extraCandies: Int): List[Boolean] = {
        val maxCandies = candies.max
        candies.map(kid => kid + extraCandies >= maxCandies).toList
    }
}
