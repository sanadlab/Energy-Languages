object Solution {
    def abbreviateProduct(left: Int, right: Int): String = {
        var p = BigInt(1)
        for (i <- left to right) {
            p *= i
        }
        var c = 0
        while (p % 10 == 0) {
            p /= 10
            c += 1
        }
        val s = p.toString
        if (s.length <= 10) s"${s}e${c}"
        else s"${s.substring(0, 5)}...${s.substring(s.length - 5)}e${c}"
    }
}
