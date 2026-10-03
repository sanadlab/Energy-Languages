#include <stdlib.h>

static int cmpll(const void* a, const void* b) {
    long long x = *(const long long*)a, y = *(const long long*)b;
    if (x < y) return -1;
    if (x > y) return 1;
    return 0;
}

static int contains(long long* keys, int n, long long key) {
    int lo = 0, hi = n - 1;
    while (lo <= hi) {
        int mid = (lo + hi) / 2;
        if (keys[mid] == key) return 1;
        if (keys[mid] < key) lo = mid + 1;
        else hi = mid - 1;
    }
    return 0;
}

int minAreaRect(int** points, int pointsSize, int* pointsColSize) {
    int n = pointsSize;
    long long* keys = (long long*)malloc(n * sizeof(long long));
    for (int i = 0; i < n; i++) {
        keys[i] = (long long)points[i][0] * 50000 + points[i][1];
    }
    qsort(keys, n, sizeof(long long), cmpll);
    long long best = -1;
    for (int i = 0; i < n; i++) {
        int x1 = points[i][0], y1 = points[i][1];
        for (int j = i + 1; j < n; j++) {
            int x2 = points[j][0], y2 = points[j][1];
            if (x1 != x2 && y1 != y2) {
                long long k1 = (long long)x1 * 50000 + y2;
                long long k2 = (long long)x2 * 50000 + y1;
                if (contains(keys, n, k1) && contains(keys, n, k2)) {
                    long long area = (long long)abs(x1 - x2) * abs(y1 - y2);
                    if (best == -1 || area < best) best = area;
                }
            }
        }
    }
    free(keys);
    return best == -1 ? 0 : (int)best;
}
