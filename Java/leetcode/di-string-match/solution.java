class Solution {
    public int[] diStringMatch(String s) {
        int n = s.length(), lo = 0, hi = n;
        int[] res = new int[n + 1];
        for (int i = 0; i < n; i++) {
            if (s.charAt(i) == 'I') res[i] = lo++;
            else res[i] = hi--;
        }
        res[n] = lo;
        return res;
    }
}
