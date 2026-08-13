class Solution {
    public boolean areOccurrencesEqual(String s) {
        int[] count = new int[26];
        for (char c : s.toCharArray()) {
            count[c - 'a']++;
        }
        
        int firstCount = -1;
        for (int c : count) {
            if (c > 0) {
                if (firstCount == -1) {
                    firstCount = c;
                } else if (c != firstCount) {
                    return false;
                }
            }
        }
        return true;
    }
}