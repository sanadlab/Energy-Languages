#include <stdlib.h>
#include <limits.h>

static int costFn(int pos_l, int pos_r, int startPos) {
    if (pos_r <= startPos) return startPos - pos_l;
    if (pos_l >= startPos) return pos_r - startPos;
    int a = startPos - pos_l;
    int b = pos_r - startPos;
    return (pos_r - pos_l) + (a < b ? a : b);
}

int maxTotalFruits(int** fruits, int fruitsSize, int* fruitsColSize, int startPos, int k) {
    int n = fruitsSize;
    long long best = 0, total = 0;
    int i = 0;
    for (int j = 0; j < n; j++) {
        total += fruits[j][1];
        while (i <= j && costFn(fruits[i][0], fruits[j][0], startPos) > k) {
            total -= fruits[i][1];
            i++;
        }
        if (i <= j && total > best) best = total;
    }
    return (int)best;
}
