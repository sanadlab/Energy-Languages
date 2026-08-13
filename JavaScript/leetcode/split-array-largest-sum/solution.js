var splitArray = function(nums, k) {
    let lo = 0, hi = 0;
    for (const x of nums) { lo = Math.max(lo, x); hi += x; }
    while (lo < hi) {
        const mid = Math.floor(lo + (hi - lo) / 2);
        let cnt = 1, cur = 0;
        for (const x of nums) {
            if (cur + x > mid) { cnt++; cur = x; }
            else cur += x;
        }
        if (cnt <= k) hi = mid;
        else lo = mid + 1;
    }
    return lo;
};
