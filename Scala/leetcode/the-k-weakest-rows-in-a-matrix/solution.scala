object Solution {
    def kWeakestRows(mat: Array[Array[Int]], k: Int): Array[Int] = {
        val counts = mat.indices.map(i => (mat(i).sum, i)).toArray
        val sorted = counts.sortBy(p => (p._1, p._2))
        sorted.take(k).map(_._2)
    }
}
