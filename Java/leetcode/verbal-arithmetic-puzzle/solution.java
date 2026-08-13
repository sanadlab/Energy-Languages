import java.util.*;

class Solution {
    private String[] words;
    private String result;
    private int[] assigned = new int[128];
    private boolean[] usedDigit = new boolean[10];
    private boolean[] leading = new boolean[128];
    private int maxLen;

    public boolean isSolvable(String[] words, String result) {
        this.words = words;
        this.result = result;
        maxLen = result.length();
        Arrays.fill(assigned, -1);
        for (String w : words) {
            if (w.length() > maxLen) return false;
            if (w.length() > 1) leading[w.charAt(0)] = true;
        }
        if (result.length() > 1) leading[result.charAt(0)] = true;
        return solve(0, 0, 0);
    }

    private boolean solve(int col, int row, int carry) {
        if (col == maxLen) return carry == 0;
        if (row < words.length) {
            String w = words[row];
            if (col >= w.length()) return solve(col, row + 1, carry);
            char ch = w.charAt(w.length() - 1 - col);
            if (assigned[ch] != -1) return solve(col, row + 1, carry);
            for (int d = 0; d <= 9; d++) {
                if (!usedDigit[d] && !(d == 0 && leading[ch])) {
                    usedDigit[d] = true;
                    assigned[ch] = d;
                    if (solve(col, row + 1, carry)) return true;
                    usedDigit[d] = false;
                    assigned[ch] = -1;
                }
            }
            return false;
        }
        int sum = carry;
        for (String w : words) {
            if (col < w.length()) sum += assigned[w.charAt(w.length() - 1 - col)];
        }
        int digit = sum % 10;
        int newCarry = sum / 10;
        char rch = result.charAt(result.length() - 1 - col);
        if (assigned[rch] != -1) {
            if (assigned[rch] == digit) return solve(col + 1, 0, newCarry);
            return false;
        }
        if (usedDigit[digit]) return false;
        if (digit == 0 && leading[rch]) return false;
        usedDigit[digit] = true;
        assigned[rch] = digit;
        if (solve(col + 1, 0, newCarry)) return true;
        usedDigit[digit] = false;
        assigned[rch] = -1;
        return false;
    }
}
