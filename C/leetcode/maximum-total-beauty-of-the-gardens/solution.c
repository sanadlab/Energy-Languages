static int cmp_int(const void* a, const void* b) {
    int x = *(const int*)a, y = *(const int*)b;
    return (x > y) - (x < y);
}

/* leftmost index in a[0..hi) with a[idx] >= x (bisect_left) */
static int bisect_left_c(int* a, int x, int hi) {
    int lo = 0;
    while (lo < hi) {
        int mid = (lo + hi) / 2;
        if (a[mid] < x) lo = mid + 1;
        else hi = mid;
    }
    return lo;
}

long long maximumBeauty(int* flowers, int flowersSize, long long newFlowers, int target, int full, int partial) {
    int n = flowersSize;
    if (n == 0) return 0;
    int* fl = (int*) malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) {
        int v = flowers[i];
        if (v > target) v = target;
        fl[i] = v;
    }
    qsort(fl, n, sizeof(int), cmp_int);
    long long* pre = (long long*) malloc(sizeof(long long) * (n + 1));
    pre[0] = 0;
    for (int i = 0; i < n; i++) pre[i + 1] = pre[i] + fl[i];
    if (fl[0] == target) {
        free(fl); free(pre);
        return (long long) full * n;
    }
    long long ans = 0;
    for (int i = n; i >= 0; i--) {
        long long cost_complete = (long long) target * (n - i) - (pre[n] - pre[i]);
        if (cost_complete > newFlowers) continue;
        long long rem = newFlowers - cost_complete;
        if (i == 0) {
            long long cand = (long long) full * (n - i);
            if (cand > ans) ans = cand;
            continue;
        }
        long long lo = 0, hi = target - 1, best_min = 0;
        while (lo <= hi) {
            long long v = (lo + hi) / 2;
            int k = bisect_left_c(fl, (int) v, i);
            long long cost = v * k - pre[k];
            if (cost <= rem) { best_min = v; lo = v + 1; }
            else hi = v - 1;
        }
        long long cand = (long long) full * (n - i) + best_min * (long long) partial;
        if (cand > ans) ans = cand;
    }
    free(fl); free(pre);
    return ans;
}
