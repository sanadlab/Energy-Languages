class Solution {
    fun spiralMatrixIII(rows: Int, cols: Int, rStart: Int, cStart: Int): Array<IntArray> {
        val total = rows * cols
        val res = ArrayList<IntArray>()
        var r = rStart
        var c = cStart
        if (r in 0 until rows && c in 0 until cols) {
            res.add(intArrayOf(r, c))
        }
        val dr = intArrayOf(0, 1, 0, -1)
        val dc = intArrayOf(1, 0, -1, 0)
        var step = 1
        var d = 0
        while (res.size < total) {
            repeat(2) {
                repeat(step) {
                    r += dr[d % 4]
                    c += dc[d % 4]
                    if (r in 0 until rows && c in 0 until cols) {
                        res.add(intArrayOf(r, c))
                    }
                }
                d++
            }
            step++
        }
        return res.toTypedArray()
    }
}
