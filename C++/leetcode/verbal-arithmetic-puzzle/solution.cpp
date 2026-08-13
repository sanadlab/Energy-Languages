class Solution {
public:
    int assigned[128];
    bool used[10];
    bool leading[128];
    vector<string>* W;
    string R;
    int maxLen;

    bool solve(int col, int row, int carry) {
        if (col == maxLen) return carry == 0;
        if (row < (int)W->size()) {
            const string& w = (*W)[row];
            if (col >= (int)w.size()) return solve(col, row + 1, carry);
            int ch = (unsigned char)w[w.size() - 1 - col];
            if (assigned[ch] != -1) return solve(col, row + 1, carry);
            for (int d = 0; d <= 9; d++) {
                if (!used[d] && !(d == 0 && leading[ch])) {
                    used[d] = true;
                    assigned[ch] = d;
                    if (solve(col, row + 1, carry)) return true;
                    used[d] = false;
                    assigned[ch] = -1;
                }
            }
            return false;
        }
        int s = carry;
        for (auto& w : *W)
            if (col < (int)w.size()) s += assigned[(unsigned char)w[w.size() - 1 - col]];
        int digit = s % 10, nc = s / 10;
        int rch = (unsigned char)R[R.size() - 1 - col];
        if (assigned[rch] != -1) {
            if (assigned[rch] == digit) return solve(col + 1, 0, nc);
            return false;
        }
        if (used[digit]) return false;
        if (digit == 0 && leading[rch]) return false;
        used[digit] = true;
        assigned[rch] = digit;
        if (solve(col + 1, 0, nc)) return true;
        used[digit] = false;
        assigned[rch] = -1;
        return false;
    }

    bool isSolvable(vector<string>& words, string result) {
        for (int i = 0; i < 128; i++) { assigned[i] = -1; leading[i] = false; }
        for (int i = 0; i < 10; i++) used[i] = false;
        maxLen = result.size();
        for (auto& w : words) if ((int)w.size() > maxLen) return false;
        for (auto& w : words) if (w.size() > 1) leading[(unsigned char)w[0]] = true;
        if (result.size() > 1) leading[(unsigned char)result[0]] = true;
        W = &words;
        R = result;
        return solve(0, 0, 0);
    }
};
