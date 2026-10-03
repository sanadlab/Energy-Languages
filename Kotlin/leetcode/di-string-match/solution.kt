class Solution {
    fun diStringMatch(s: String): IntArray {
        var low = 0
        var high = s.length
        val perm = IntArray(s.length + 1)
        var idx = 0
        for (char in s) {
            if (char == 'I') {
                perm[idx] = low
                low++
            } else {
                perm[idx] = high
                high--
            }
            idx++
        }
        perm[idx] = low
        return perm
    }
}
