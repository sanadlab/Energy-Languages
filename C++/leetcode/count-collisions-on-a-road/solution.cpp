class Solution {
public:
    int countCollisions(string directions) {
        int n = directions.size();
        int left = 0, right = n - 1;

        // Skip all leading 'L' cars (they move left and won't collide with anyone)
        while (left < n && directions[left] == 'L') left++;
        // Skip all trailing 'R' cars (they move right and won't collide with anyone)
        while (right >= 0 && directions[right] == 'R') right--;

        // Now consider the substring directions[left..right]
        // All cars here will eventually collide or become stationary.
        // The collisions count is total moving cars in this range minus the stationary cars.
        // Because after collisions, all moving cars become stationary.

        int collisions = 0;
        for (int i = left; i <= right; i++) {
            if (directions[i] != 'S') collisions++;
        }

        return collisions;
    }
};