import java.math.BigInteger

class Solution {
    fun abbreviateProduct(left: Int, right: Int): String {
        var p = BigInteger.ONE
        for (i in left..right) {
            p = p.multiply(BigInteger.valueOf(i.toLong()))
        }
        var c = 0
        val ten = BigInteger.TEN
        while (p.mod(ten) == BigInteger.ZERO) {
            p = p.divide(ten)
            c++
        }
        val s = p.toString()
        if (s.length <= 10) {
            return "${s}e${c}"
        }
        return "${s.substring(0, 5)}...${s.substring(s.length - 5)}e${c}"
    }
}
