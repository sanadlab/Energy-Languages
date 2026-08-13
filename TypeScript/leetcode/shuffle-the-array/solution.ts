function shuffle(nums: number[], n: number): number[] {
    const m = Math.floor(nums.length / 2);
    const res: number[] = [];
    for (let i = 0; i < m; i++) {
        res.push(nums[i], nums[i + m]);
    }
    return res;
}
