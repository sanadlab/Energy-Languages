#include <stdlib.h>

typedef struct { long long key; int val; } MDEntry;

static int mdSolve(long long x, MDEntry* tab, int cap) {
    if (x <= 1) return (int)x;
    unsigned long long h = (unsigned long long)x * 1125899906842597ULL;
    int idx = (int)(h % (unsigned long long)cap);
    while (tab[idx].key != 0 && tab[idx].key != x) idx = (idx + 1) % cap;
    if (tab[idx].key == x) return tab[idx].val;
    int a = (int)(x % 2) + mdSolve(x / 2, tab, cap);
    int b = (int)(x % 3) + mdSolve(x / 3, tab, cap);
    int res = 1 + (a < b ? a : b);
    idx = (int)(h % (unsigned long long)cap);
    while (tab[idx].key != 0 && tab[idx].key != x) idx = (idx + 1) % cap;
    tab[idx].key = x;
    tab[idx].val = res;
    return res;
}

int minDays(int n) {
    int cap = 1 << 16;
    MDEntry* tab = (MDEntry*)calloc(cap, sizeof(MDEntry));
    int res = mdSolve(n, tab, cap);
    free(tab);
    return res;
}
