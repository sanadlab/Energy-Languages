function maximumBeauty(flowers: number[], newFlowers: number, target: number, full: number, partial: number): number {
    const n = flowers.length;
    if (n === 0) return 0;
    const fl = flowers.map(f => Math.min(f, target)).sort((a, b) => a - b);
    const pre = new Array(n + 1).fill(0);
    for (let i = 0; i < n; i++) pre[i + 1] = pre[i] + fl[i];
    if (fl[0] === target) return full * n;
    const lowerBound = (hiIdx: number, v: number): number => {
        let lo = 0, hi = hiIdx;
        while (lo < hi) { const mid = (lo + hi) >> 1; if (fl[mid] < v) lo = mid + 1; else hi = mid; }
        return lo;
    };
    let ans = 0;
    for (let i = n; i >= 0; i--) {
        const costComplete = target * (n - i) - (pre[n] - pre[i]);
        if (costComplete > newFlowers) continue;
        const rem = newFlowers - costComplete;
        if (i === 0) { ans = Math.max(ans, full * (n - i)); continue; }
        let lo = 0, hi = target - 1, bestMin = 0;
        while (lo <= hi) {
            const v = lo + ((hi - lo) >> 1);
            const k = lowerBound(i, v);
            const cost = v * k - pre[k];
            if (cost <= rem) { bestMin = v; lo = v + 1; } else { hi = v - 1; }
        }
        ans = Math.max(ans, full * (n - i) + bestMin * partial);
    }
    return ans;
}
