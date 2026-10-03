class Solution {
    func sortByBits(_ arr: [Int]) -> [Int] {
        return arr.sorted { a, b in
            let pa = a.nonzeroBitCount, pb = b.nonzeroBitCount
            if pa != pb { return pa < pb }
            return a < b
        }
    }
}
