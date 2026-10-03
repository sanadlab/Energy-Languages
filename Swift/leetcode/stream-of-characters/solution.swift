
class StreamChecker {

    final class TrieNode {
        var children: [Character: TrieNode] = [:]
        var isEnd = false
    }

    private let trie = TrieNode()
    private var stream: [Character] = []
    private var maxLen = 0

    init(_ words: [String]) {
        for w in words {
            var node = trie
            for ch in w.reversed() {
                if let next = node.children[ch] {
                    node = next
                } else {
                    let newNode = TrieNode()
                    node.children[ch] = newNode
                    node = newNode
                }
            }
            node.isEnd = true
            if w.count > maxLen {
                maxLen = w.count
            }
        }
    }

    func query(_ letter: Character) -> Bool {
        stream.append(letter)
        var node = trie
        let n = stream.count
        for step in 0..<min(maxLen, n) {
            let ch = stream[n - 1 - step]
            guard let next = node.children[ch] else {
                return false
            }
            node = next
            if node.isEnd {
                return true
            }
        }
        return false
    }
}

/**
 * Your StreamChecker object will be instantiated and called as such:
 * let obj = StreamChecker(words)
 * let ret_1: Bool = obj.query(letter)
 */
