class Solution:
    def spiralMatrixIII(self, rows, cols, rStart, cStart):
        total = rows * cols
        res = []
        r, c = rStart, cStart
        if 0 <= r < rows and 0 <= c < cols:
            res.append([r, c])
        dr = [0, 1, 0, -1]
        dc = [1, 0, -1, 0]
        step = 1
        d = 0
        while len(res) < total:
            for _ in range(2):
                for _ in range(step):
                    r += dr[d % 4]
                    c += dc[d % 4]
                    if 0 <= r < rows and 0 <= c < cols:
                        res.append([r, c])
                d += 1
            step += 1
        return res
