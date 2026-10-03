class Solution {
    func uncommonFromSentences(_ s1: String, _ s2: String) -> [String] {
        let combined = s1 + " " + s2
        let words = combined.split(separator: " ").map { String($0) }
        var count = [String: Int]()
        var order = [String]()
        for w in words {
            if count[w] == nil { order.append(w) }
            count[w, default: 0] += 1
        }
        var result = [String]()
        for w in order where count[w] == 1 { result.append(w) }
        return result
    }
}
