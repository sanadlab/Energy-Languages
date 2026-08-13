public class Solution {
    public int[] DiStringMatch(string s) {
        int n = s.Length, lo = 0, hi = n;
        int[] res = new int[n + 1];
        for (int i = 0; i < n; i++) {
            if (s[i] == 'I') res[i] = lo++;
            else res[i] = hi--;
        }
        res[n] = lo;
        return res;
    }
}
