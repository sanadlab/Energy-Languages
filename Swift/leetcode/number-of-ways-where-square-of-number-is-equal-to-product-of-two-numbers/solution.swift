class Solution {
    func numTriplets(_ nums1: [Int], _ nums2: [Int]) -> Int {
        func helper(_ a: [Int], _ b: [Int]) -> Int {
            var cnt = 0
            for x in a {
                let t = x * x
                var seen = [Int: Int]()
                for y in b {
                    if y != 0 && t % y == 0 {
                        let need = t / y
                        cnt += seen[need, default: 0]
                    }
                    seen[y, default: 0] += 1
                }
            }
            return cnt
        }
        return helper(nums1, nums2) + helper(nums2, nums1)
    }
}
