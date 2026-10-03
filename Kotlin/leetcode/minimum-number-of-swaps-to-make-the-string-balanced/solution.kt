class Solution {
    fun minSwaps(s: String): Int {
        var open = 0
        for (c in s) {
            if (c == '[') {
                open++
            } else if (open > 0) {
                open--
            }
        }
        return (open + 1) / 2
    }
}
