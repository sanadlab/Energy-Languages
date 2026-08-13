class Solution {
    public int minSwaps(String s) {
        int open = 0;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '[') open++;
            else if (open > 0) open--;
        }
        return (open + 1) / 2;
    }
}
