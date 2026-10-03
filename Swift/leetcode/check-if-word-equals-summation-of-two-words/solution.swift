class Solution {
    func isSumEqual(_ firstWord: String, _ secondWord: String, _ targetWord: String) -> Bool {
        let base = Int(Character("a").asciiValue!)
        func digits(_ word: String) -> [Int] {
            return word.unicodeScalars.map { Int($0.value) - base }
        }
        func strip(_ a: [Int]) -> [Int] {
            var k = 0
            while k < a.count - 1 && a[k] == 0 { k += 1 }
            return Array(a[k...])
        }
        func add(_ a: [Int], _ b: [Int]) -> [Int] {
            var i = a.count - 1
            var j = b.count - 1
            var carry = 0
            var rev: [Int] = []
            while i >= 0 || j >= 0 || carry > 0 {
                let x = i >= 0 ? a[i] : 0
                let y = j >= 0 ? b[j] : 0
                let s = x + y + carry
                rev.append(s % 10)
                carry = s / 10
                i -= 1
                j -= 1
            }
            return strip(Array(rev.reversed()))
        }
        let sum = add(digits(firstWord), digits(secondWord))
        return sum == strip(digits(targetWord))
    }
}
