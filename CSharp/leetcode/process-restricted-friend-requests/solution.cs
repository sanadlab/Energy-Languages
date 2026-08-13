public class Solution {
    private int[] parent;

    private int Find(int x) {
        while (parent[x] != x) { parent[x] = parent[parent[x]]; x = parent[x]; }
        return x;
    }

    public bool[] FriendRequests(int n, int[][] restrictions, int[][] requests) {
        parent = new int[n];
        for (int i = 0; i < n; i++) parent[i] = i;
        bool[] res = new bool[requests.Length];
        for (int idx = 0; idx < requests.Length; idx++) {
            int u = requests[idx][0], v = requests[idx][1];
            int pu = Find(u), pv = Find(v);
            if (pu == pv) { res[idx] = true; continue; }
            bool ok = true;
            foreach (var r in restrictions) {
                int px = Find(r[0]), py = Find(r[1]);
                if ((px == pu && py == pv) || (px == pv && py == pu)) { ok = false; break; }
            }
            if (ok) { parent[pu] = pv; res[idx] = true; }
            else res[idx] = false;
        }
        return res;
    }
}
