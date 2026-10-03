class Solution {
    func removePalindromeSub(_ s: String) -> Int {
        if s.isEmpty { return 0 }
        let chars = Array(s)
        var i = 0, j = chars.count - 1
        while i < j {
            if chars[i] != chars[j] { return 2 }
            i += 1
            j -= 1
        }
        return 1
    }
}
