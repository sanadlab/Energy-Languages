class Solution {
    func sumOddLengthSubarrays(_ arr: [Int]) -> Int {
        let n = arr.count
        var total = 0
        for i in 0..<n {
            let count = ((i + 1) * (n - i) + 1) / 2
            total += count * arr[i]
        }
        return total
    }
}
