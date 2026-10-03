class Solution {
    func numSmallerByFrequency(_ queries: [String], _ words: [String]) -> [Int] {
        func f(_ s: String) -> Int {
            var minChar: Character? = nil
            var count = 0
            for c in s {
                if minChar == nil || c < minChar! {
                    minChar = c
                    count = 1
                } else if c == minChar! {
                    count += 1
                }
            }
            return count
        }
        var wordFreqs = words.map { f($0) }
        wordFreqs.sort()
        var result = [Int]()
        for query in queries {
            let qFreq = f(query)
            let target = qFreq + 1
            var left = 0
            var right = wordFreqs.count - 1
            while left <= right {
                let mid = (left + right) / 2
                if wordFreqs[mid] < target {
                    left = mid + 1
                } else {
                    right = mid - 1
                }
            }
            result.append(words.count - left)
        }
        return result
    }
}
