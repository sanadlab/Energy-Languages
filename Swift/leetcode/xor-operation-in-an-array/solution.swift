class Solution {
    func xorOperation(_ n: Int, _ start: Int) -> Int {
        var result = 0
        for i in 0..<n {
            let num = start + 2 * i
            result ^= num
        }
        return result
    }
}
