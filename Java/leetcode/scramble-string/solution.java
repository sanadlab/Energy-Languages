class Solution {
    public boolean isScramble(String s1, String s2) {
        if (s1.equals(s2)) return true;
        if (s1.length() != s2.length()) return false;

        int[] count = new int[26];
        for (int i = 0; i < s1.length(); i++) {
            count[s1.charAt(i) - 'a']++;
            count[s2.charAt(i) - 'a']--;
        }
        for (int c : count)
            if (c != 0) return false;

        int n = s1.length();
        for (int i = 1; i < n; i++) {
            String a1 = s1.substring(0, i);
            String b1 = s1.substring(i);

            // no swap: first i of s1 vs first i of s2, rest vs rest
            if (isScramble(a1, s2.substring(0, i)) && isScramble(b1, s2.substring(i))) {
                return true;
            }
            // swap: first i of s1 vs last i of s2, rest of s1 vs first n-i of s2
            if (isScramble(a1, s2.substring(n - i)) && isScramble(b1, s2.substring(0, n - i))) {
                return true;
            }
        }
        return false;
    }
}