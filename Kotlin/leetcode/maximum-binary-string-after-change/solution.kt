class Solution {
    fun maximumBinaryString(binary: String): String {
        val n = binary.length
        val first = binary.indexOf('0')
        if (first == -1) return binary
        val zeros = binary.count { it == '0' }
        val res = CharArray(n) { '1' }
        res[first + zeros - 1] = '0'
        return String(res)
    }
}
