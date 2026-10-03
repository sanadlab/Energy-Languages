class Solution {
    func daysBetweenDates(_ date1: String, _ date2: String) -> Int {
        return abs(days(date1) - days(date2))
    }

    func days(_ s: String) -> Int {
        let parts = s.split(separator: "-", omittingEmptySubsequences: false)
        var vals = [0, 0, 0]
        let limit = min(3, parts.count)
        for i in 0..<limit {
            vals[i] = Int(parts[i]) ?? 0
        }
        return daysFromCivil(vals[0], vals[1], vals[2])
    }

    func daysFromCivil(_ y0: Int, _ m: Int, _ d: Int) -> Int {
        var y = y0
        y -= (m <= 2) ? 1 : 0
        let era = y / 400
        let yoe = y - era * 400
        let doy = (153 * (m + (m > 2 ? -3 : 9)) + 2) / 5 + d - 1
        let doe = yoe * 365 + yoe / 4 - yoe / 100 + doy
        return era * 146097 + doe - 719468
    }
}
