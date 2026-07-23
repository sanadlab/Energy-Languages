function minSteps(n: number): number {
    if (n === 1) return 0;
    let ans = 0, d = 2;
    while (n > 1) {
        while (n % d === 0) { ans += d; n = Math.floor(n / d); }
        d++;
    }
    return ans;
}
