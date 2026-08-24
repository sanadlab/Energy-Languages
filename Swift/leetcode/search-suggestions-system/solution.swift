class Solution {
    func suggestedProducts(_ products: [String], _ searchWord: String) -> [[String]] {
        let ps = products.sorted(); let sw = Array(searchWord); var res = [[String]]()
        for L in 1...sw.count {
            let pre = String(sw[0..<L]); var row = [String]()
            for p in ps { if p.hasPrefix(pre) { row.append(p); if row.count == 3 { break } } }
            res.append(row)
        }
        return res
    }
}
