#include <stdlib.h>

int maxStudents(char** seats, int seatsSize, int* seatsColSize) {
    int m = seatsSize;
    if (m == 0) return 0;
    int n = seatsColSize[0];
    int* avail = (int*)calloc(m, sizeof(int));
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n && j < seatsColSize[i]; j++) {
            if (seats[i][j] == '.') avail[i] |= (1 << j);
        }
    }
    int full = 1 << n;
    int* best = (int*)malloc(full * sizeof(int));
    int* ndp = (int*)malloc(full * sizeof(int));
    for (int mask = 0; mask < full; mask++) best[mask] = -1;
    best[0] = 0;
    for (int i = 0; i < m; i++) {
        for (int mask = 0; mask < full; mask++) ndp[mask] = -1;
        for (int mask = 0; mask < full; mask++) {
            if ((mask & avail[i]) != mask) continue;
            if (mask & (mask << 1)) continue;
            int pc = __builtin_popcount(mask);
            for (int pmask = 0; pmask < full; pmask++) {
                if (best[pmask] < 0) continue;
                if (mask & (pmask << 1)) continue;
                if (mask & (pmask >> 1)) continue;
                int val = best[pmask] + pc;
                if (val > ndp[mask]) ndp[mask] = val;
            }
        }
        int* tmp = best; best = ndp; ndp = tmp;
    }
    int res = -1;
    for (int mask = 0; mask < full; mask++) if (best[mask] > res) res = best[mask];
    free(avail); free(best); free(ndp);
    return res;
}
