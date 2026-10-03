class Solution {
    func licenseKeyFormatting(_ s: String, _ k: Int) -> String {
        var cleaned = [Character]()
        for c in s {
            if c != "-" {
                for u in String(c).uppercased() { cleaned.append(u) }
            }
        }
        let len = cleaned.count
        let firstGroupLen = len % k
        var groups = [String]()
        if firstGroupLen > 0 {
            groups.append(String(cleaned[0..<firstGroupLen]))
        }
        var i = firstGroupLen
        while i < len {
            let end = min(i + k, len)
            groups.append(String(cleaned[i..<end]))
            i += k
        }
        return groups.joined(separator: "-")
    }
}
