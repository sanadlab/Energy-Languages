class Solution {
    func removeInvalidParentheses(_ s: String) -> [String] {
        func valid(_ t: [Character]) -> Bool {
            var c = 0
            for ch in t { if ch == "(" { c += 1 } else if ch == ")" { c -= 1; if c < 0 { return false } } }
            return c == 0
        }
        var level: Set<String> = [s]
        while true {
            let found = level.filter { valid(Array($0)) }
            if !found.isEmpty { return Array(found) }
            var next = Set<String>()
            for t in level {
                let a = Array(t)
                for i in 0..<a.count where a[i] == "(" || a[i] == ")" {
                    var b = a; b.remove(at: i); next.insert(String(b))
                }
            }
            if next.isEmpty { return [""] }
            level = next
        }
    }
}
