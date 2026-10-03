class Solution {
    func ambiguousCoordinates(_ s: String) -> [String] {
        let chars = Array(s)
        let digits = Array(chars[1..<(chars.count - 1)])
        let n = digits.count
        var res: [String] = []
        if n >= 2 {
            for i in 1..<n {
                let left = Array(digits[0..<i])
                let right = Array(digits[i..<n])
                for a in make(left) {
                    for b in make(right) {
                        res.append("(\(a), \(b))")
                    }
                }
            }
        }
        return res
    }

    func make(_ d: [Character]) -> [String] {
        var out: [String] = []
        let n = d.count
        if n == 1 {
            out.append(String(d))
            return out
        }
        if d[0] != "0" {
            out.append(String(d))
        }
        for i in 1..<n {
            let l = Array(d[0..<i])
            let r = Array(d[i..<n])
            let lOK = (l.count == 1 && l[0] == "0") || l[0] != "0"
            if lOK && r.last != "0" {
                out.append(String(l) + "." + String(r))
            }
        }
        return out
    }
}
