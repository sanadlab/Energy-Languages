object Solution {
    def maxTotalFruits(fruits: Array[Array[Int]], startPos: Int, k: Int): Int = {
        def cost(posL: Int, posR: Int): Int = {
            if (posR <= startPos) startPos - posL
            else if (posL >= startPos) posR - startPos
            else (posR - posL) + math.min(startPos - posL, posR - startPos)
        }
        val n = fruits.length
        var best = 0
        var total = 0
        var i = 0
        for (j <- 0 until n) {
            total += fruits(j)(1)
            while (i <= j && cost(fruits(i)(0), fruits(j)(0)) > k) {
                total -= fruits(i)(1)
                i += 1
            }
            if (i <= j && total > best) best = total
        }
        best
    }
}
