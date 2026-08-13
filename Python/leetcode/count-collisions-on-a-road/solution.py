class Solution:
    def countCollisions(self, directions: str) -> int:
        n = len(directions)
        # Leading 'L' cars drive off to the left and never collide.
        i = 0
        while i < n and directions[i] == 'L':
            i += 1
        # Trailing 'R' cars drive off to the right and never collide.
        j = n - 1
        while j >= 0 and directions[j] == 'R':
            j -= 1
        # Every remaining moving car ('L' or 'R') eventually collides and
        # contributes exactly 1 to the total collision count.
        collisions = 0
        for k in range(i, j + 1):
            if directions[k] != 'S':
                collisions += 1
        return collisions
