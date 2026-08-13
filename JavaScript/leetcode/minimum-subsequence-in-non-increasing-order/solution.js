var minSubsequence = function(nums) {
    nums.sort((a, b) => b - a);
    const total = nums.reduce((s, x) => s + x, 0);
    let running = 0;
    const res = [];
    for (const x of nums) {
        running += x;
        res.push(x);
        if (running * 2 > total) break;
    }
    return res;
};
