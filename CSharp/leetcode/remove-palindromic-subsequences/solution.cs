public class Solution {
    public int RemovePalindromeSub(string s) {
        if (string.IsNullOrEmpty(s)) return 0;
        int l = 0, r = s.Length - 1;
        while (l < r) {
            if (s[l] != s[r]) return 2;
            l++; r--;
        }
        return 1;
    }
}
