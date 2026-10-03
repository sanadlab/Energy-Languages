class Solution {
    func ladderLength(_ beginWord: String, _ endWord: String, _ wordList: [String]) -> Int {
        let wordSet = Set(wordList)
        if !wordSet.contains(endWord) {
            return 0
        }
        let letters = Array("abcdefghijklmnopqrstuvwxyz")
        var queue: [(Array<Character>, Int)] = [(Array(beginWord), 1)]
        var head = 0
        var visited: Set<String> = [beginWord]
        while head < queue.count {
            let (current, level) = queue[head]
            head += 1
            for i in 0..<current.count {
                var chars = current
                let original = current[i]
                for c in letters {
                    chars[i] = c
                    let nextWord = String(chars)
                    if nextWord == endWord {
                        return level + 1
                    }
                    if wordSet.contains(nextWord) && !visited.contains(nextWord) {
                        queue.append((chars, level + 1))
                        visited.insert(nextWord)
                    }
                }
                chars[i] = original
            }
        }
        return 0
    }
}
