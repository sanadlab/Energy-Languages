class Solution {
    public int countCollisions(String directions) {
        int n = directions.length();
        // Leading 'L' cars drive off to the left and never collide.
        int i = 0;
        while (i < n && directions.charAt(i) == 'L') {
            i++;
        }
        // Trailing 'R' cars drive off to the right and never collide.
        int j = n - 1;
        while (j >= 0 && directions.charAt(j) == 'R') {
            j--;
        }
        // Every remaining moving car ('L' or 'R') eventually collides and
        // contributes exactly 1 to the total collision count.
        int collisions = 0;
        for (int k = i; k <= j; k++) {
            if (directions.charAt(k) != 'S') {
                collisions++;
            }
        }
        return collisions;
    }
}
