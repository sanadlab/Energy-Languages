class Solution {
    func spiralMatrixIII(_ rows: Int, _ cols: Int, _ rStart: Int, _ cStart: Int) -> [[Int]] {
        let total = rows * cols
        var res = [[Int]]()
        var r = rStart, c = cStart
        if r >= 0 && r < rows && c >= 0 && c < cols {
            res.append([r, c])
        }
        let dr = [0, 1, 0, -1]
        let dc = [1, 0, -1, 0]
        var step = 1
        var d = 0
        while res.count < total {
            for _ in 0..<2 {
                for _ in 0..<step {
                    r += dr[d % 4]
                    c += dc[d % 4]
                    if r >= 0 && r < rows && c >= 0 && c < cols {
                        res.append([r, c])
                    }
                }
                d += 1
            }
            step += 1
        }
        return res
    }
}
