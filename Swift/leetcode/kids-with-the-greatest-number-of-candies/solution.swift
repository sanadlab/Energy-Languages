class Solution {
    func kidsWithCandies(_ candies: [Int], _ extraCandies: Int) -> [Bool] {
        let maxC = candies.max() ?? 0
        return candies.map { $0 + extraCandies >= maxC }
    }
}
