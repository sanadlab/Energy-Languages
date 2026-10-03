#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

bool isMatch(char* s, char* p) {
    int m = (int)strlen(s), n = (int)strlen(p);
    bool* dp = calloc((size_t)(m + 1) * (n + 1), sizeof(bool));
    #define DP(i, j) dp[(size_t)(i) * (n + 1) + (j)]
    DP(0, 0) = true;

    for (int j = 1; j <= n; j++) {
        if (p[j - 1] == '*') DP(0, j) = DP(0, j - 1);
    }

    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n; j++) {
            if (p[j - 1] == s[i - 1] || p[j - 1] == '?') {
                DP(i, j) = DP(i - 1, j - 1);
            } else if (p[j - 1] == '*') {
                DP(i, j) = DP(i - 1, j) || DP(i, j - 1);
            }
        }
    }

    bool ans = DP(m, n);
    #undef DP
    free(dp);
    return ans;
}
