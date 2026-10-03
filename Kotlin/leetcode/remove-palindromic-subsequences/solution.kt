class Solution {
    fun removePalindromeSub(s: String): Int {
        if (s.isEmpty()) return 0
        return if (s == s.reversed()) 1 else 2
    }
}
