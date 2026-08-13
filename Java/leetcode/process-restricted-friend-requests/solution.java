class Solution {
    private int[] parent;

    private int find(int x) {
        while (parent[x] != x) { parent[x] = parent[parent[x]]; x = parent[x]; }
        return x;
    }

    public boolean[] friendRequests(int n, int[][] restrictions, int[][] requests) {
        parent = new int[n];
        for (int i = 0; i < n; i++) parent[i] = i;
        boolean[] res = new boolean[requests.length];
        for (int idx = 0; idx < requests.length; idx++) {
            int u = requests[idx][0], v = requests[idx][1];
            int pu = find(u), pv = find(v);
            if (pu == pv) { res[idx] = true; continue; }
            boolean ok = true;
            for (int[] r : restrictions) {
                int px = find(r[0]), py = find(r[1]);
                if ((px == pu && py == pv) || (px == pv && py == pu)) { ok = false; break; }
            }
            if (ok) { parent[pu] = pv; res[idx] = true; }
            else res[idx] = false;
        }
        return res;
    }
}
