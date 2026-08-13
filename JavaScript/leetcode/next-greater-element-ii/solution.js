var nextGreaterElements = function(nums) {
    const n = nums.length;
    const res = new Array(n).fill(-1);
    const st = [];
    for (let i = 0; i < 2 * n; i++) {
        const cur = nums[i % n];
        while (st.length && nums[st[st.length - 1]] < cur) {
            res[st.pop()] = cur;
        }
        if (i < n) st.push(i);
    }
    return res;
};
