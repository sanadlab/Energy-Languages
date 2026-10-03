#include <stdlib.h>
#include <limits.h>

typedef struct { int e, l; char done; } EalMemo;
static EalMemo g_memo[30][30][30];

static void eal_dp(int m, int f, int s, int* oe, int* ol) {
    if (f > s) { int t = f; f = s; s = t; }
    EalMemo* mm = &g_memo[m][f][s];
    if (mm->done) { *oe = mm->e; *ol = mm->l; return; }
    if (f + s == m + 1) { mm->e = 1; mm->l = 1; mm->done = 1; *oe = 1; *ol = 1; return; }
    int new_m = (m + 1) / 2;

    int fixed_win[32]; int nfw = 0;
    int fp[16][2]; int nfp = 0;
    for (int p = 1; p <= m / 2; p++) {
        int q = m + 1 - p;
        if (f == p || f == q) fixed_win[nfw++] = f;
        else if (s == p || s == q) fixed_win[nfw++] = s;
        else { fp[nfp][0] = p; fp[nfp][1] = q; nfp++; }
    }
    if (m % 2 == 1) fixed_win[nfw++] = (m + 1) / 2;

    int fixed_below_f = 0, fixed_below_s = 0;
    for (int i = 0; i < nfw; i++) {
        if (fixed_win[i] < f) fixed_below_f++;
        if (fixed_win[i] < s) fixed_below_s++;
    }

    int earliest = INT_MAX, latest = INT_MIN;
    int combos = 1 << nfp;
    for (int msk = 0; msk < combos; msk++) {
        int bf = fixed_below_f, bs = fixed_below_s;
        for (int b = 0; b < nfp; b++) {
            int w = (msk & (1 << b)) ? fp[b][1] : fp[b][0];
            if (w < f) bf++;
            if (w < s) bs++;
        }
        int e, l;
        eal_dp(new_m, bf + 1, bs + 1, &e, &l);
        if (e + 1 < earliest) earliest = e + 1;
        if (l + 1 > latest) latest = l + 1;
    }
    mm->e = earliest; mm->l = latest; mm->done = 1;
    *oe = earliest; *ol = latest;
}

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* earliestAndLatest(int n, int firstPlayer, int secondPlayer, int* returnSize) {
    int e, l;
    eal_dp(n, firstPlayer, secondPlayer, &e, &l);
    int* res = (int*) malloc(sizeof(int) * 2);
    res[0] = e; res[1] = l;
    *returnSize = 2;
    return res;
}
