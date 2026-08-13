public class Solution {
    public int MinAreaRect(int[][] points) {
        var seen = new HashSet<long>();
        int n = points.Length;
        foreach (var p in points) seen.Add((long)p[0] * 50000L + p[1]);
        long best = long.MaxValue;
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                int x1 = points[i][0], y1 = points[i][1];
                int x2 = points[j][0], y2 = points[j][1];
                if (x1 != x2 && y1 != y2) {
                    if (seen.Contains((long)x1 * 50000L + y2) &&
                        seen.Contains((long)x2 * 50000L + y1)) {
                        long area = (long)Math.Abs(x1 - x2) * Math.Abs(y1 - y2);
                        best = Math.Min(best, area);
                    }
                }
            }
        }
        return best == long.MaxValue ? 0 : (int)best;
    }
}
