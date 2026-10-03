class Solution {
    func nextGreaterElements(_ nums: [Int]) -> [Int] {
        let n = nums.count
        var res = [Int](repeating: -1, count: n)
        var st = [Int]()
        for i in 0..<(2 * n) {
            let cur = nums[i % n]
            while let top = st.last, nums[top] < cur {
                res[st.removeLast()] = cur
            }
            if i < n {
                st.append(i)
            }
        }
        return res
    }
}
