public class Solution {
    public int MaxPoints(int[][] points) {
        int n = points.Length;
        if (n <= 2) return n;
        int best = 1;
        for (int i = 0; i < n; i++) {
            var slopes = new Dictionary<(int, int), int>();
            for (int j = i + 1; j < n; j++) {
                int dx = points[j][0] - points[i][0];
                int dy = points[j][1] - points[i][1];
                int g = Gcd(Math.Abs(dx), Math.Abs(dy));
                dx /= g;
                dy /= g;
                if (dx < 0 || (dx == 0 && dy < 0)) { dx = -dx; dy = -dy; }
                var key = (dx, dy);
                slopes.TryGetValue(key, out int c);
                c++;
                slopes[key] = c;
                if (c + 1 > best) best = c + 1;
            }
        }
        return best;
    }

    private int Gcd(int a, int b) {
        while (b != 0) { int t = b; b = a % b; a = t; }
        return a;
    }
}
