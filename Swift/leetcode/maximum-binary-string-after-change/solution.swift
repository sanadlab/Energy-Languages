class Solution {
    func maximumBinaryString(_ binary: String) -> String {
        let chars = Array(binary)
        let n = chars.count
        var first = -1
        for i in 0..<n {
            if chars[i] == "0" {
                first = i
                break
            }
        }
        if first == -1 {
            return binary
        }
        var zeros = 0
        for ch in chars {
            if ch == "0" {
                zeros += 1
            }
        }
        var res = [Character](repeating: "1", count: n)
        res[first + zeros - 1] = "0"
        return String(res)
    }
}
