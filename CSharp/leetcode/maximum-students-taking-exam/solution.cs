public class Solution {
    public int MaxStudents(char[][] seats) {
        int m = seats.Length;
        if (m == 0) return 0;
        int n = seats[0].Length;
        int[] avail = new int[m];
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n && j < seats[i].Length; j++)
                if (seats[i][j] == '.') avail[i] |= (1 << j);
        int full = 1 << n;
        int[] best = new int[full];
        for (int k = 0; k < full; k++) best[k] = -1;
        best[0] = 0;
        for (int i = 0; i < m; i++) {
            int[] ndp = new int[full];
            for (int k = 0; k < full; k++) ndp[k] = -1;
            for (int mask = 0; mask < full; mask++) {
                if ((mask & avail[i]) != mask) continue;
                if ((mask & (mask << 1)) != 0) continue;
                int pc = System.Numerics.BitOperations.PopCount((uint)mask);
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
        foreach (int v in best) ans = Math.Max(ans, v);
        return ans;
    }
}
