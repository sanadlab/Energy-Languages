function canCross(stones: number[]): boolean {
    const n = stones.length;
    const index = new Map<number, number>();
    for (let i = 0; i < n; i++) index.set(stones[i], i);
    const dp: Set<number>[] = Array.from({ length: n }, () => new Set<number>());
    dp[0].add(0);
    for (let i = 0; i < n; i++) {
        for (const k of dp[i]) {
            for (const step of [k - 1, k, k + 1]) {
                if (step > 0) {
                    const pos = stones[i] + step;
                    if (index.has(pos)) {
                        const j = index.get(pos)!;
                        if (j !== i) dp[j].add(step);
                    }
                }
            }
        }
    }
    return dp[n - 1].size > 0;
}
