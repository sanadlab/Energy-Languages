class Solution {
    fun kWeakestRows(mat: Array<IntArray>, k: Int): IntArray {
        val counts = Array(mat.size) { i -> intArrayOf(mat[i].sum(), i) }
        counts.sortWith(compareBy({ it[0] }, { it[1] }))
        val res = IntArray(k)
        for (i in 0 until k) res[i] = counts[i][1]
        return res
    }
}
