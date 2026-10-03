object Solution {
    def maximumBinaryString(binary: String): String = {
        val n = binary.length
        val first = binary.indexOf('0')
        if (first == -1) return binary
        val zeros = binary.count(_ == '0')
        val res = Array.fill(n)('1')
        res(first + zeros - 1) = '0'
        new String(res)
    }
}
