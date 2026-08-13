import java.util.*;

class Solution {
    public List<Integer> eventualSafeNodes(int[][] graph) {
        int n = graph.length;
        List<List<Integer>> rev = new ArrayList<>();
        for (int i = 0; i < n; i++) rev.add(new ArrayList<>());
        int[] outdeg = new int[n];
        for (int u = 0; u < n; u++) {
            for (int v : graph[u]) {
                if (v >= 0 && v < n) {
                    rev.get(v).add(u);
                    outdeg[u]++;
                }
            }
        }
        Queue<Integer> q = new LinkedList<>();
        for (int i = 0; i < n; i++) if (outdeg[i] == 0) q.add(i);
        boolean[] safe = new boolean[n];
        while (!q.isEmpty()) {
            int v = q.poll();
            safe[v] = true;
            for (int u : rev.get(v)) {
                if (--outdeg[u] == 0) q.add(u);
            }
        }
        List<Integer> res = new ArrayList<>();
        for (int i = 0; i < n; i++) if (safe[i]) res.add(i);
        return res;
    }
}
