class Solution {
    func findKDistantIndices(_ nums: [Int], _ key: Int, _ k: Int) -> [Int] {
        var result = [Int]()
        let n = nums.count
        for i in 0..<n {
            var found = false
            for j in 0..<n {
                if abs(i - j) <= k && nums[j] == key {
                    found = true
                    break
                }
            }
            if found { result.append(i) }
        }
        return result
    }
}
