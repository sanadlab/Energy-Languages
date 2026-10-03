class Solution {
    func areOccurrencesEqual(_ s: String) -> Bool {
        var counts: [Character: Int] = [:]
        for ch in s {
            counts[ch, default: 0] += 1
        }
        return Set(counts.values).count == 1
    }
}
