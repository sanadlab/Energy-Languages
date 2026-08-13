function medianSlidingWindow(nums: number[], k: number): number[] {
    const res: number[] = [];
    const n = nums.length;
    for (let i = 0; i + k <= n; i++) {
        const w = nums.slice(i, i + k).sort((a, b) => a - b);
        let median: number;
        if (k % 2 === 1) median = w[(k - 1) / 2];
        else median = (w[k / 2 - 1] + w[k / 2]) / 2;
        res.push(median);
    }
    return res;
}
