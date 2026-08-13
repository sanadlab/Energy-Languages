class Solution {
    public String maximumBinaryString(String binary) {
        int n = binary.length();
        int first = -1, zeros = 0;
        for (int i = 0; i < n; i++) {
            if (binary.charAt(i) == '0') { if (first == -1) first = i; zeros++; }
        }
        if (first == -1) return binary;
        char[] res = new char[n];
        java.util.Arrays.fill(res, '1');
        res[first + zeros - 1] = '0';
        return new String(res);
    }
}
