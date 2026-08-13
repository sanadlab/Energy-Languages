class Solution {
    public int countVowelSubstrings(String word) {
        int result = 0;
        int n = word.length();
        for (int i = 0; i < n; i++) {
            boolean[] seen = new boolean[26];
            int count = 0;
            for (int j = i; j < n; j++) {
                char c = word.charAt(j);
                if ("aeiou".indexOf(c) < 0) break;
                if (!seen[c - 'a']) {
                    seen[c - 'a'] = true;
                    count++;
                }
                if (count == 5) result++;
            }
        }
        return result;
    }
}
