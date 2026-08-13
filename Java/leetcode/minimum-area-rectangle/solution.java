class Solution {
    public int minAreaRect(int[][] points) {
        java.util.HashSet<Long> seen = new java.util.HashSet<>();
        int n = points.length;
        for (int[] p : points) seen.add((long) p[0] * 50000L + p[1]);
        long best = Long.MAX_VALUE;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                int x1 = points[i][0], y1 = points[i][1];
                int x2 = points[j][0], y2 = points[j][1];
                if (x1 != x2 && y1 != y2) {
                    if (seen.contains((long) x1 * 50000L + y2) &&
                        seen.contains((long) x2 * 50000L + y1)) {
                        long area = (long) Math.abs(x1 - x2) * Math.abs(y1 - y2);
                        best = Math.min(best, area);
                    }
                }
            }
        }
        return best == Long.MAX_VALUE ? 0 : (int) best;
    }
}
