class Solution {
    func maxEqualFreq(_ nums: [Int]) -> Int {
        let n = nums.count
        var count = [Int](repeating: 0, count: 100001)
        var freq = [Int](repeating: 0, count: n + 1)
        var maxF = 0
        var res = 0
        for i in 0..<n {
            let v = nums[i]
            if count[v] > 0 {
                freq[count[v]] -= 1
            }
            count[v] += 1
            freq[count[v]] += 1
            if count[v] > maxF {
                maxF = count[v]
            }
            if maxF == 1
                || freq[maxF] * maxF == i
                || (freq[maxF] == 1 && (maxF - 1) * (freq[maxF - 1] + 1) == i) {
                res = i + 1
            }
        }
        return res
    }
}
