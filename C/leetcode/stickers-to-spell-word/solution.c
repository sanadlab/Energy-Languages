#include <stdlib.h>
#include <string.h>
#include <limits.h>

int minStickers(char** stickers, int stickersSize, char* target) {
    int n = (int)strlen(target);
    int full = (1 << n) - 1;
    int size = 1 << n;
    int INF = INT_MAX;

    int* dp = malloc((size_t)size * sizeof(int));
    for (int i = 0; i < size; i++) dp[i] = INF;
    dp[0] = 0;

    int (*cnt)[26] = malloc((size_t)stickersSize * sizeof(*cnt));
    for (int s = 0; s < stickersSize; s++) {
        for (int j = 0; j < 26; j++) cnt[s][j] = 0;
        for (char* p = stickers[s]; *p; p++) cnt[s][*p - 'a']++;
    }

    for (int state = 0; state < size; state++) {
        if (dp[state] == INF) continue;
        for (int s = 0; s < stickersSize; s++) {
            int avail[26];
            for (int j = 0; j < 26; j++) avail[j] = cnt[s][j];
            int nxt = state;
            for (int i = 0; i < n; i++) {
                if (!(state & (1 << i))) {
                    int idx = target[i] - 'a';
                    if (avail[idx] > 0) {
                        avail[idx]--;
                        nxt |= (1 << i);
                    }
                }
            }
            if (dp[state] + 1 < dp[nxt]) dp[nxt] = dp[state] + 1;
        }
    }

    int ans = (dp[full] == INF) ? -1 : dp[full];
    free(dp);
    free(cnt);
    return ans;
}
