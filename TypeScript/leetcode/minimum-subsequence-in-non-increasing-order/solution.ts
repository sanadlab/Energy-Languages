function minSubsequence(nums: number[]): number[] {
    nums.sort((a, b) => b - a);
    const total = nums.reduce((s, x) => s + x, 0);
    let running = 0;
    const res: number[] = [];
    for (const x of nums) {
        running += x;
        res.push(x);
        if (running * 2 > total) break;
    }
    return res;
}
