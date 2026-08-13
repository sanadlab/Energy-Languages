public class Solution {
    public int[] RestoreArray(int[][] adjacentPairs) {
        var adj = new Dictionary<int, List<int>>();
        foreach (var p in adjacentPairs) {
            if (!adj.ContainsKey(p[0])) adj[p[0]] = new List<int>();
            if (!adj.ContainsKey(p[1])) adj[p[1]] = new List<int>();
            adj[p[0]].Add(p[1]);
            adj[p[1]].Add(p[0]);
        }
        int n = adjacentPairs.Length + 1;
        int start = adjacentPairs.Length > 0 ? adjacentPairs[0][0] : 0;
        foreach (var e in adj) {
            if (e.Value.Count == 1) { start = e.Key; break; }
        }
        var res = new List<int>{ start };
        int prev = start, cur = start;
        bool hasPrev = false;
        while (res.Count < n) {
            int nxt = 0; bool found = false;
            if (adj.TryGetValue(cur, out var nbrs)) {
                foreach (int x in nbrs) {
                    if (!hasPrev || x != prev) { nxt = x; found = true; break; }
                }
            }
            if (!found) break;
            res.Add(nxt);
            prev = cur; hasPrev = true; cur = nxt;
        }
        return res.ToArray();
    }
}
