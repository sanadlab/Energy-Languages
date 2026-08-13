function maxEqualFreq(nums: number[]): number {
    const n = nums.length;
    const count = new Array(100001).fill(0);
    const freq = new Array(n + 1).fill(0);
    let maxF = 0, res = 0;
    for (let i = 0; i < n; i++) {
        const v = nums[i];
        if (count[v] > 0) freq[count[v]]--;
        count[v]++;
        freq[count[v]]++;
        if (count[v] > maxF) maxF = count[v];
        if (maxF === 1 ||
            freq[maxF] * maxF === i ||
            (freq[maxF] === 1 && (maxF - 1) * (freq[maxF - 1] + 1) === i)) {
            res = i + 1;
        }
    }
    return res;
}
