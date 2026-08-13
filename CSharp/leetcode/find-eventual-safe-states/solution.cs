public class Solution {
    public IList<int> EventualSafeNodes(int[][] graph) {
        int n = graph.Length;
        var rev = new List<int>[n];
        for (int i = 0; i < n; i++) rev[i] = new List<int>();
        var outdeg = new int[n];
        for (int u = 0; u < n; u++) {
            foreach (int v in graph[u]) {
                if (v >= 0 && v < n) {
                    rev[v].Add(u);
                    outdeg[u]++;
                }
            }
        }
        var q = new Queue<int>();
        for (int i = 0; i < n; i++) if (outdeg[i] == 0) q.Enqueue(i);
        var safe = new bool[n];
        while (q.Count > 0) {
            int v = q.Dequeue();
            safe[v] = true;
            foreach (int u in rev[v]) {
                if (--outdeg[u] == 0) q.Enqueue(u);
            }
        }
        var res = new List<int>();
        for (int i = 0; i < n; i++) if (safe[i]) res.Add(i);
        return res;
    }
}
