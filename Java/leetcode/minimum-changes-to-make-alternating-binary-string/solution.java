class Solution {
    public int minOperations(String s) {
        int cnt = 0, n = s.length();
        for (int i = 0; i < n; i++) {
            char expected = (i % 2 == 0) ? '0' : '1';
            if (s.charAt(i) != expected) cnt++;
        }
        return Math.min(cnt, n - cnt);
    }
}
