#include <stdlib.h>

static int gcd_i(int a, int b) {
    while (b != 0) {
        int t = a % b;
        a = b;
        b = t;
    }
    return a;
}

int maxPoints(int** points, int pointsSize, int* pointsColSize) {
    int n = pointsSize;
    if (n <= 2) return n;

    int best = 1;
    // per anchor i, collect normalized slope keys and count duplicates
    int* kx = (int*)malloc(sizeof(int) * n);
    int* ky = (int*)malloc(sizeof(int) * n);
    int* cnt = (int*)malloc(sizeof(int) * n);

    for (int i = 0; i < n; i++) {
        int m = 0;
        for (int j = i + 1; j < n; j++) {
            int dx = points[j][0] - points[i][0];
            int dy = points[j][1] - points[i][1];
            int g = gcd_i(abs(dx), abs(dy));
            dx /= g;
            dy /= g;
            if (dx < 0 || (dx == 0 && dy < 0)) { dx = -dx; dy = -dy; }
            int f = -1;
            for (int t = 0; t < m; t++) {
                if (kx[t] == dx && ky[t] == dy) { f = t; break; }
            }
            if (f < 0) { kx[m] = dx; ky[m] = dy; cnt[m] = 1; f = m; m++; }
            else cnt[f]++;
            if (cnt[f] + 1 > best) best = cnt[f] + 1;
        }
    }
    free(kx); free(ky); free(cnt);
    return best;
}
