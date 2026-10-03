class Solution {
    fun maxTotalFruits(fruits: Array<IntArray>, startPos: Int, k: Int): Int {
        fun cost(posL: Int, posR: Int): Int {
            if (posR <= startPos) return startPos - posL
            if (posL >= startPos) return posR - startPos
            return (posR - posL) + minOf(startPos - posL, posR - startPos)
        }

        val n = fruits.size
        var best = 0
        var total = 0
        var i = 0
        for (j in 0 until n) {
            total += fruits[j][1]
            while (i <= j && cost(fruits[i][0], fruits[j][0]) > k) {
                total -= fruits[i][1]
                i += 1
            }
            if (i <= j && total > best) best = total
        }
        return best
    }
}
