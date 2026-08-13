function nextGreaterElements(nums: number[]): number[] {
    const n = nums.length;
    const res: number[] = new Array(n).fill(-1);
    const st: number[] = [];
    for (let i = 0; i < 2 * n; i++) {
        const cur = nums[i % n];
        while (st.length && nums[st[st.length - 1]] < cur) {
            const idx = st.pop() as number;
            res[idx] = cur;
        }
        if (i < n) st.push(i);
    }
    return res;
}
