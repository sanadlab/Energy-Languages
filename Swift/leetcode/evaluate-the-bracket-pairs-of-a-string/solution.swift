class Solution {
    func evaluate(_ s: String, _ knowledge: [[String]]) -> String {
        var dict = [String: String]()
        for kv in knowledge {
            dict[kv[0]] = kv[1]
        }
        var stack = [String]()
        var word = ""
        for char in s {
            if char == "(" {
                stack.append(word)
                word = ""
            } else if char == ")" {
                let prev = stack.removeLast() + (dict[word] ?? "?")
                word = prev
            } else {
                word.append(char)
            }
        }
        return word
    }
}
