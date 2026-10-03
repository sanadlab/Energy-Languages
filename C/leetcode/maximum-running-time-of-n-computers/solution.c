long long maxRunTime(int n, int* batteries, int batteriesSize) {
    long long total = 0;
    for (int i = 0; i < batteriesSize; i++) total += batteries[i];
    long long lo = 0, hi = total / n;
    while (lo < hi) {
        long long mid = (lo + hi + 1) / 2;
        long long avail = 0;
        for (int i = 0; i < batteriesSize; i++) {
            avail += (batteries[i] < mid ? batteries[i] : mid);
        }
        if (avail >= (long long)n * mid) lo = mid;
        else hi = mid - 1;
    }
    return lo;
}
