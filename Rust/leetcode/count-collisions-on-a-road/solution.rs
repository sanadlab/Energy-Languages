impl Solution {
    pub fn count_collisions(directions: String) -> i32 {
        let directions = directions.as_bytes();
        let n = directions.len();

        // Skip all leading 'L' cars (they move left and won't collide with anyone)
        let mut left = 0;
        while left < n && directions[left] == b'L' {
            left += 1;
        }

        // Skip all trailing 'R' cars (they move right and won't collide with anyone)
        let mut right = n as i32 - 1;
        while right >= 0 && directions[right as usize] == b'R' {
            right -= 1;
        }

        // Now consider the substring directions[left..=right]
        // All cars here will eventually collide or become stationary.
        // The collisions count is total cars in this substring minus the stationary cars already there.
        // Because after collisions, all cars in this range become stationary.

        if right < left as i32 {
            // No cars in the middle range, no collisions
            return 0;
        }

        let mut stationary_count = 0;
        for i in left..=right as usize {
            if directions[i] == b'S' {
                stationary_count += 1;
            }
        }

        // Total cars in the middle range
        let total = (right - left as i32 + 1) as i32;

        // Collisions = total cars in middle range - stationary cars already there
        total - stationary_count
    }
}