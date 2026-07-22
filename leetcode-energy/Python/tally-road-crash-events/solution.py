class Solution:
    def countCollisions(self, directions: str) -> int:
        # Trim all leading 'L' cars (they move left and won't collide with anyone)
        left = 0
        while left < len(directions) and directions[left] == 'L':
            left += 1
        
        # Trim all trailing 'R' cars (they move right and won't collide with anyone)
        right = len(directions) - 1
        while right >= 0 and directions[right] == 'R':
            right -= 1
        
        # Now consider the substring directions[left:right+1]
        # All cars here will eventually collide or become stationary.
        # The collisions count is the number of moving cars in this substring.
        # Because:
        # - Cars moving right that meet cars moving left cause 2 collisions.
        # - Cars moving right or left that hit stationary cars cause 1 collision.
        # After the initial collisions, all cars in this substring become stationary.
        # So total collisions = count of all 'L' and 'R' in this substring.
        
        collisions = 0
        for i in range(left, right + 1):
            if directions[i] != 'S':
                collisions += 1
        
        return collisions
