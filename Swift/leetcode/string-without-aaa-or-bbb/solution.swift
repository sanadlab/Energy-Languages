class Solution {
    func strWithout3a3b(_ a: Int, _ b: Int) -> String {
        var a = a
        var b = b
        var res = [Character]()
        while a > 0 || b > 0 {
            let n = res.count
            var writeA: Bool
            if n >= 2 && res[n - 1] == res[n - 2] {
                writeA = res[n - 1] == "b"
            } else {
                writeA = a >= b
            }
            if writeA {
                if a == 0 { break }
                res.append("a")
                a -= 1
            } else {
                if b == 0 { break }
                res.append("b")
                b -= 1
            }
        }
        return String(res)
    }
}
