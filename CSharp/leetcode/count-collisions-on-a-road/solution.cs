public class Solution {
    public int CountCollisions(string directions) {
        int n = directions.Length;
        int collisions = 0;
        char[] cars = directions.ToCharArray();

        // Remove leading 'L's - these cars move left and won't collide with anyone
        int left = 0;
        while (left < n && cars[left] == 'L') left++;

        // Remove trailing 'R's - these cars move right and won't collide with anyone
        int right = n - 1;
        while (right >= 0 && cars[right] == 'R') right--;

        // Now consider the substring cars[left..right]
        // All 'R' cars here will eventually collide or stop
        // All 'L' cars here will eventually collide or stop
        // 'S' cars are stationary and cause collisions with moving cars

        // Count collisions:
        // Every 'R' in this range will collide at least once (turn into 'S')
        // Every 'L' in this range will collide at least once (turn into 'S')
        // Each collision between opposite directions counts as 2 collisions
        // But after collision, cars become stationary, so collisions with stationary cars count as 1

        // The problem can be simplified:
        // The total collisions = number of cars moving right in [left..right] + number of cars moving left in [left..right]
        // Because all these moving cars will collide eventually.
        // But the problem states collisions between opposite directions count as 2,
        // and collisions with stationary cars count as 1.
        // Actually, the total collisions = total number of moving cars in [left..right] - number of stationary cars in [left..right]
        // Because stationary cars don't move, but cause collisions with moving cars.

        // Another way:
        // Total collisions = total cars in [left..right] - number of stationary cars in [left..right]
        // Because stationary cars don't cause collisions themselves, but moving cars colliding with stationary cars count as 1 collision each.
        // And collisions between opposite moving cars count as 2, but after collision they become stationary, so the count is included.

        // So the formula is:
        // collisions = (number of cars in [left..right]) - (number of stationary cars in [left..right])

        int stationaryCount = 0;
        for (int i = left; i <= right; i++) {
            if (cars[i] == 'S') stationaryCount++;
        }

        collisions = (right - left + 1) - stationaryCount;
        return collisions;
    }
}