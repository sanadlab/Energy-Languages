class Solution {
    public int sumOddLengthSubarrays(int[] arr) {
        long total = 0;
        int n = arr.length;
        for (int i = 0; i < n; i++) {
            long count = ((long)(i + 1) * (n - i) + 1) / 2;
            total += count * arr[i];
        }
        return (int) total;
    }
}
