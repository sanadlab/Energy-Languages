public class Solution {
    public int MinOperations(string s) {
        int cnt = 0, n = s.Length;
        for (int i = 0; i < n; i++) {
            char expected = (i % 2 == 0) ? '0' : '1';
            if (s[i] != expected) cnt++;
        }
        return Math.Min(cnt, n - cnt);
    }
}
