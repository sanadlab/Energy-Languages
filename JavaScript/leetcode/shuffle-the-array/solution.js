var shuffle = function(nums, n) {
    const m = Math.floor(nums.length / 2);
    const res = [];
    for (let i = 0; i < m; i++) {
        res.push(nums[i], nums[i + m]);
    }
    return res;
};
