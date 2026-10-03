class Solution {
    func average(_ salary: [Int]) -> Double {
        var mn = salary[0], mx = salary[0], total = 0
        for s in salary {
            total += s
            mn = min(mn, s); mx = max(mx, s)
        }
        return Double(total - mn - mx) / Double(salary.count - 2)
    }
}
