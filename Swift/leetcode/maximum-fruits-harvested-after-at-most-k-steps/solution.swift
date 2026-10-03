class Solution {
    func maxTotalFruits(_ fruits: [[Int]], _ startPos: Int, _ k: Int) -> Int {
        func cost(_ posL: Int, _ posR: Int) -> Int {
            if posR <= startPos { return startPos - posL }
            if posL >= startPos { return posR - startPos }
            return (posR - posL) + min(startPos - posL, posR - startPos)
        }
        let n = fruits.count
        var best = 0
        var total = 0
        var i = 0
        for j in 0..<n {
            total += fruits[j][1]
            while i <= j && cost(fruits[i][0], fruits[j][0]) > k {
                total -= fruits[i][1]
                i += 1
            }
            if i <= j && total > best { best = total }
        }
        return best
    }
}
