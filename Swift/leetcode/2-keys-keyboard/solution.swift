class Solution {
    func minSteps(_ n: Int) -> Int {
        var steps = 0, d = 2, n = n
        while n > 1 { while n % d == 0 { steps += d; n /= d }; d += 1 }
        return steps
    }
}
