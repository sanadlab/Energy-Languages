import java.util.*;
class Solution {
    public int[] kWeakestRows(int[][] mat, int k) {
        int n = mat.length;
        int[][] rows = new int[n][2];
        for (int i = 0; i < n; i++) {
            int c = 0;
            for (int v : mat[i]) if (v == 1) c++;
            rows[i][0] = c; rows[i][1] = i;
        }
        Arrays.sort(rows, (a, b) -> a[0] != b[0] ? a[0] - b[0] : a[1] - b[1]);
        int lim = Math.min(k, n);
        int[] res = new int[lim];
        for (int i = 0; i < lim; i++) res[i] = rows[i][1];
        return res;
    }
}
