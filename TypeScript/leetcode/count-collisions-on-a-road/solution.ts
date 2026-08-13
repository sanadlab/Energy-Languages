function countCollisions(directions: string): number {
    const n = directions.length;
    let i = 0;
    while (i < n && directions[i] === 'L') i++;
    let j = n - 1;
    while (j >= 0 && directions[j] === 'R') j--;
    let count = 0;
    for (let k = i; k <= j; k++) {
        if (directions[k] !== 'S') count++;
    }
    return count;
}
