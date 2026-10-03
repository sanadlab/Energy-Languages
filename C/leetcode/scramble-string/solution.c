#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

static bool check_equal(const char* s1, const char* s2, int i1, int i2, int length) {
    int cnt[256] = {0};
    for (int k = 0; k < length; k++) {
        cnt[(unsigned char)s1[i1 + k]]++;
        cnt[(unsigned char)s2[i2 + k]]--;
    }
    for (int k = 0; k < 256; k++) if (cnt[k] != 0) return false;
    return true;
}

bool isScramble(char* s1, char* s2) {
    int n = (int)strlen(s1);
    if ((int)strlen(s2) != n) return false;
    if (n == 0) return true;

    size_t total = (size_t)(n + 1) * n * n;
    bool* dp = calloc(total, sizeof(bool));
#define DP(L, I, J) dp[((size_t)(L) * n + (I)) * n + (J)]

    for (int length = 1; length <= n; length++) {
        for (int i = 0; i + length <= n; i++) {
            for (int j = 0; j + length <= n; j++) {
                if (!check_equal(s1, s2, i, j, length)) continue;
                if (length == 1) {
                    DP(length, i, j) = true;
                } else {
                    for (int k = 1; k < length; k++) {
                        if ((DP(k, i, j) && DP(length - k, i + k, j + k)) ||
                            (DP(k, i, j + length - k) && DP(length - k, i + k, j))) {
                            DP(length, i, j) = true;
                            break;
                        }
                    }
                }
            }
        }
    }

    bool ans = DP(n, 0, 0);
#undef DP
    free(dp);
    return ans;
}
