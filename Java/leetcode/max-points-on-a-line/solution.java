import java.util.*;

class Solution {
    public int maxPoints(int[][] points) {
        int n = points.length;
        if (n <= 2) return n;
        int best = 1;
        for (int i = 0; i < n; i++) {
            Map<Long, Integer> slopes = new HashMap<>();
            for (int j = i + 1; j < n; j++) {
                int dx = points[j][0] - points[i][0];
                int dy = points[j][1] - points[i][1];
                int g = gcd(Math.abs(dx), Math.abs(dy));
                dx /= g;
                dy /= g;
                if (dx < 0 || (dx == 0 && dy < 0)) { dx = -dx; dy = -dy; }
                long key = (long) dx * 1000000L + dy;
                int c = slopes.getOrDefault(key, 0) + 1;
                slopes.put(key, c);
                if (c + 1 > best) best = c + 1;
            }
        }
        return best;
    }

    private int gcd(int a, int b) {
        while (b != 0) { int t = b; b = a % b; a = t; }
        return a;
    }
}
