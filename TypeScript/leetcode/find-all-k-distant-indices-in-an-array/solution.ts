function findKDistantIndices(nums: number[], key: number, k: number): number[] {
    const n = nums.length;
    const mark: boolean[] = new Array(n).fill(false);
    for (let j = 0; j < n; j++) {
        if (nums[j] === key) {
            const lo = Math.max(0, j - k);
            const hi = Math.min(n - 1, j + k);
            for (let i = lo; i <= hi; i++) mark[i] = true;
        }
    }
    const res: number[] = [];
    for (let i = 0; i < n; i++) if (mark[i]) res.push(i);
    return res;
}
