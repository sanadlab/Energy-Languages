class Solution {
    func closeStrings(_ word1: String, _ word2: String) -> Bool {
        if word1.count != word2.count { return false }
        var freq1 = [Int](repeating: 0, count: 26)
        var freq2 = [Int](repeating: 0, count: 26)
        let a = Int(UnicodeScalar("a").value)
        for c in word1.unicodeScalars { freq1[Int(c.value) - a] += 1 }
        for c in word2.unicodeScalars { freq2[Int(c.value) - a] += 1 }
        for i in 0..<26 {
            if (freq1[i] > 0 && freq2[i] == 0) || (freq2[i] > 0 && freq1[i] == 0) {
                return false
            }
        }
        return freq1.sorted() == freq2.sorted()
    }
}
