public class Solution {
    public string MaximumBinaryString(string binary) {
        int n = binary.Length;
        int first = -1, zeros = 0;
        for (int i = 0; i < n; i++) {
            if (binary[i] == '0') { if (first == -1) first = i; zeros++; }
        }
        if (first == -1) return binary;
        char[] res = new char[n];
        for (int i = 0; i < n; i++) res[i] = '1';
        res[first + zeros - 1] = '0';
        return new string(res);
    }
}
