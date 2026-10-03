class Solution {
    func countVowelSubstrings(_ word: String) -> Int {
        let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
        let chars = Array(word)
        let n = chars.count
        var count = 0
        for i in 0..<n {
            if !vowels.contains(chars[i]) { continue }
            var seen = Set<Character>()
            var j = i
            while j < n && vowels.contains(chars[j]) {
                seen.insert(chars[j])
                if seen.count == 5 { count += 1 }
                j += 1
            }
        }
        return count
    }
}
