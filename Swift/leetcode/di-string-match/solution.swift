class Solution {
    func diStringMatch(_ s: String) -> [Int] {
        let chars = Array(s); var lo = 0, hi = chars.count, res = [Int]()
        for c in chars { if c == "I" { res.append(lo); lo += 1 } else { res.append(hi); hi -= 1 } }
        res.append(lo); return res
    }
}
