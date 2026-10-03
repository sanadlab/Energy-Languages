class Solution {
    func minDays(_ n: Int) -> Int {
        var memo: [Int: Int] = [:]
        func solve(_ x: Int) -> Int {
            if x <= 1 { return x }
            if let v = memo[x] { return v }
            let res = 1 + min(x % 2 + solve(x / 2), x % 3 + solve(x / 3))
            memo[x] = res
            return res
        }
        return solve(n)
    }
}
