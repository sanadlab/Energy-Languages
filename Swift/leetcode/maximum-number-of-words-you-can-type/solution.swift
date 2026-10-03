class Solution {
    func canBeTypedWords(_ text: String, _ brokenLetters: String) -> Int {
        let broken = Set(brokenLetters)
        var count = 0
        for word in text.split(separator: " ") {
            var ok = true
            for ch in word {
                if broken.contains(ch) {
                    ok = false
                    break
                }
            }
            if ok {
                count += 1
            }
        }
        return count
    }
}
