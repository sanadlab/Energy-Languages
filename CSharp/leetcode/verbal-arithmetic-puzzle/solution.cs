public class Solution {
    private string[] words;
    private string result;
    private int[] assigned = new int[128];
    private bool[] usedDigit = new bool[10];
    private bool[] leading = new bool[128];
    private int maxLen;

    public bool IsSolvable(string[] words, string result) {
        this.words = words;
        this.result = result;
        maxLen = result.Length;
        for (int i = 0; i < 128; i++) assigned[i] = -1;
        foreach (var w in words) {
            if (w.Length > maxLen) return false;      // a word longer than result is impossible
            if (w.Length > 1) leading[w[0]] = true;   // no leading zero on multi-letter words
        }
        if (result.Length > 1) leading[result[0]] = true;
        return Solve(0, 0, 0);
    }

    // col: column index counted from the right; row: which word we are assigning; carry.
    private bool Solve(int col, int row, int carry) {
        if (col == maxLen) return carry == 0;
        if (row < words.Length) {
            string w = words[row];
            if (col >= w.Length) return Solve(col, row + 1, carry);
            char ch = w[w.Length - 1 - col];
            if (assigned[ch] != -1) return Solve(col, row + 1, carry);
            for (int d = 0; d <= 9; d++) {
                if (!usedDigit[d] && !(d == 0 && leading[ch])) {
                    usedDigit[d] = true;
                    assigned[ch] = d;
                    if (Solve(col, row + 1, carry)) return true;
                    usedDigit[d] = false;
                    assigned[ch] = -1;
                }
            }
            return false;
        }
        int sum = carry;
        foreach (var w in words) {
            if (col < w.Length) sum += assigned[w[w.Length - 1 - col]];
        }
        int digit = sum % 10;
        int newCarry = sum / 10;
        char rch = result[result.Length - 1 - col];
        if (assigned[rch] != -1) {
            if (assigned[rch] == digit) return Solve(col + 1, 0, newCarry);
            return false;
        }
        if (usedDigit[digit]) return false;
        if (digit == 0 && leading[rch]) return false;
        usedDigit[digit] = true;
        assigned[rch] = digit;
        if (Solve(col + 1, 0, newCarry)) return true;
        usedDigit[digit] = false;
        assigned[rch] = -1;
        return false;
    }
}
