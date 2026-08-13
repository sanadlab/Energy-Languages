var minDays = function(bloomDay, m, k) {
    if (m * k > bloomDay.length) return -1;
    let lo = bloomDay[0], hi = bloomDay[0];
    for (const b of bloomDay) { if (b < lo) lo = b; if (b > hi) hi = b; }
    const canMake = (day) => {
        let bouquets = 0, flowers = 0;
        for (const b of bloomDay) {
            if (b <= day) {
                flowers++;
                if (flowers === k) { bouquets++; flowers = 0; }
            } else {
                flowers = 0;
            }
        }
        return bouquets >= m;
    };
    while (lo < hi) {
        const mid = Math.floor((lo + hi) / 2);
        if (canMake(mid)) hi = mid;
        else lo = mid + 1;
    }
    return lo;
};
