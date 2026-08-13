class Solution {
    public int maxStudents(char[][] seats) {
        int m = seats.length;
        if (m == 0) return 0;
        int n = seats[0].length;
        int[] avail = new int[m];
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n && j < seats[i].length; j++)
                if (seats[i][j] == '.') avail[i] |= (1 << j);
        int full = 1 << n;
        int[] best = new int[full];
        java.util.Arrays.fill(best, -1);
        best[0] = 0;
        for (int i = 0; i < m; i++) {
            int[] ndp = new int[full];
            java.util.Arrays.fill(ndp, -1);
            for (int mask = 0; mask < full; mask++) {
                if ((mask & avail[i]) != mask) continue;
                if ((mask & (mask << 1)) != 0) continue;
                int pc = Integer.bitCount(mask);
                for (int pmask = 0; pmask < full; pmask++) {
                    if (best[pmask] < 0) continue;
                    if ((mask & (pmask << 1)) != 0) continue;
                    if ((mask & (pmask >> 1)) != 0) continue;
                    int val = best[pmask] + pc;
                    if (val > ndp[mask]) ndp[mask] = val;
                }
            }
            best = ndp;
        }
        int ans = 0;
        for (int v : best) ans = Math.max(ans, v);
        return ans;
    }
}
