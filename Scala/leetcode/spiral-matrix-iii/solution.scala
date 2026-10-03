import scala.collection.mutable

object Solution {
    def spiralMatrixIII(rows: Int, cols: Int, rStart: Int, cStart: Int): Array[Array[Int]] = {
        val total = rows * cols
        val res = mutable.ArrayBuffer[Array[Int]]()
        var r = rStart; var c = cStart
        if (r >= 0 && r < rows && c >= 0 && c < cols) res += Array(r, c)
        val dr = Array(0, 1, 0, -1)
        val dc = Array(1, 0, -1, 0)
        var step = 1
        var d = 0
        while (res.length < total) {
            var twice = 0
            while (twice < 2) {
                var s = 0
                while (s < step) {
                    r += dr(d % 4)
                    c += dc(d % 4)
                    if (r >= 0 && r < rows && c >= 0 && c < cols) res += Array(r, c)
                    s += 1
                }
                d += 1
                twice += 1
            }
            step += 1
        }
        res.toArray
    }
}
