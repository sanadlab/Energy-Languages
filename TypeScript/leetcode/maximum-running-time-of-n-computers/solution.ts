function maxRunTime(n: number, batteries: number[]): number {
    let sum = 0n;
    for (const b of batteries) sum += BigInt(b);
    const N = BigInt(n);
    let lo = 0n, hi = sum / N;
    while (lo < hi) {
        const mid = (lo + hi + 1n) / 2n;
        let avail = 0n;
        for (const b of batteries) {
            const bb = BigInt(b);
            avail += bb < mid ? bb : mid;
        }
        if (avail >= N * mid) lo = mid; else hi = mid - 1n;
    }
    return Number(lo);
}
