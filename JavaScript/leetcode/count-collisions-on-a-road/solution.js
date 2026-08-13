var countCollisions = function(directions) {
    // Remove all leading 'L' cars because they move left and no one is to their left to collide
    let left = 0;
    while (left < directions.length && directions[left] === 'L') {
        left++;
    }
    // Remove all trailing 'R' cars because they move right and no one is to their right to collide
    let right = directions.length - 1;
    while (right >= 0 && directions[right] === 'R') {
        right--;
    }
    // Now consider the substring directions[left..right]
    // All cars here will eventually collide or become stationary
    // The number of collisions is total cars in this substring minus the number of stationary cars in it
    let collisions = 0;
    for (let i = left; i <= right; i++) {
        if (directions[i] !== 'S') collisions++;
    }
    return collisions;
};