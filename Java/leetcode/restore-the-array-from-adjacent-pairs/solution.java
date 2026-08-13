import java.util.*;

class Solution {
    public int[] restoreArray(int[][] adjacentPairs) {
        Map<Integer, List<Integer>> adj = new HashMap<>();
        for (int[] p : adjacentPairs) {
            adj.computeIfAbsent(p[0], k -> new ArrayList<>()).add(p[1]);
            adj.computeIfAbsent(p[1], k -> new ArrayList<>()).add(p[0]);
        }
        int n = adjacentPairs.length + 1;
        int start = adjacentPairs.length > 0 ? adjacentPairs[0][0] : 0;
        for (Map.Entry<Integer, List<Integer>> e : adj.entrySet()) {
            if (e.getValue().size() == 1) { start = e.getKey(); break; }
        }
        int[] res = new int[n];
        int idx = 0;
        res[idx++] = start;
        int prev = start, cur = start;
        boolean hasPrev = false;
        while (idx < n) {
            Integer nxt = null;
            List<Integer> nbrs = adj.get(cur);
            if (nbrs != null) {
                for (int x : nbrs) {
                    if (!hasPrev || x != prev) { nxt = x; break; }
                }
            }
            if (nxt == null) break;
            res[idx++] = nxt;
            prev = cur; hasPrev = true; cur = nxt;
        }
        return Arrays.copyOf(res, idx);
    }
}
