class Solution {
    func numOfWays(_ nums: [Int]) -> Int {
        let MOD = 1_000_000_007
        let n = nums.count
        var C = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: n + 1)
        for i in 0...n {
            C[i][0] = 1
            if i >= 1 {
                for j in 1...i {
                    C[i][j] = (C[i - 1][j - 1] + C[i - 1][j]) % MOD
                }
            }
        }
        func ways(_ arr: [Int]) -> Int {
            let m = arr.count
            if m <= 2 {
                return 1
            }
            let root = arr[0]
            var left = [Int]()
            var right = [Int]()
            for k in 1..<m {
                let x = arr[k]
                if x < root {
                    left.append(x)
                } else if x > root {
                    right.append(x)
                }
            }
            return C[m - 1][left.count] * ways(left) % MOD * ways(right) % MOD
        }
        return ((ways(nums) - 1) % MOD + MOD) % MOD
    }
}
