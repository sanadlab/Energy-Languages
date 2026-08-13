class Solution {
    public int canBeTypedWords(String text, String brokenLetters) {
        boolean[] broken = new boolean[26];
        for (char c : brokenLetters.toCharArray())
            if (c >= 'a' && c <= 'z') broken[c - 'a'] = true;
        int count = 0;
        boolean ok = true;
        for (int i = 0; i <= text.length(); i++) {
            if (i == text.length() || text.charAt(i) == ' ') {
                if (ok) count++;
                ok = true;
            } else {
                char c = text.charAt(i);
                if (c >= 'a' && c <= 'z' && broken[c - 'a']) ok = false;
            }
        }
        return count;
    }
}
