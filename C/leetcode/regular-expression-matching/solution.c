#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

bool isMatch(char* s, char* p) {
    int m = (int)strlen(s), n = (int)strlen(p);
    bool** dp = malloc((size_t)(m + 1) * sizeof(bool*));
    for (int i = 0; i <= m; i++) dp[i] = calloc((size_t)(n + 1), sizeof(bool));
    dp[m][n] = true;

    for (int i = m; i >= 0; i--) {
        for (int j = n - 1; j >= 0; j--) {
            bool first = (i < m) && (p[j] == s[i] || p[j] == '.');
            if (j + 1 < n && p[j + 1] == '*') {
                dp[i][j] = dp[i][j + 2] || (first && dp[i + 1][j]);
            } else {
                dp[i][j] = first && dp[i + 1][j + 1];
            }
        }
    }

    bool ans = dp[0][0];
    for (int i = 0; i <= m; i++) free(dp[i]);
    free(dp);
    return ans;
}
