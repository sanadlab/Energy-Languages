class Solution {
public:
    string maximumBinaryString(string binary) {
        int n = binary.size();
        int first = -1, zeros = 0;
        for (int i = 0; i < n; ++i) {
            if (binary[i] == '0') { if (first == -1) first = i; zeros++; }
        }
        if (first == -1) return binary;
        string res(n, '1');
        res[first + zeros - 1] = '0';
        return res;
    }
};
