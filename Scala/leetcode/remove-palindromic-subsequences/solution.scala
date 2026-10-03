object Solution {
    def removePalindromeSub(s: String): Int = {
        if (s.isEmpty) return 0
        if (s == s.reverse) 1 else 2
    }
}
