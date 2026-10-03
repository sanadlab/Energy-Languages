#include <stdlib.h>
#include <limits.h>

int minSessions(int* tasks, int tasksSize, int sessionTime) {
    int n = tasksSize;
    int full = (1 << n) - 1;
    int size = 1 << n;
    const int INF = INT_MAX;
    int* sessions = malloc(size * sizeof(int));
    int* used = malloc(size * sizeof(int));
    for (int i = 0; i < size; i++) { sessions[i] = INF; used[i] = 0; }
    sessions[0] = 1;
    for (int mask = 0; mask <= full; mask++) {
        if (sessions[mask] == INF) continue;
        for (int i = 0; i < n; i++) {
            if (mask & (1 << i)) continue;
            int nm = mask | (1 << i);
            int ns, nu;
            if (used[mask] + tasks[i] <= sessionTime) {
                ns = sessions[mask];
                nu = used[mask] + tasks[i];
            } else {
                ns = sessions[mask] + 1;
                nu = tasks[i];
            }
            if (ns < sessions[nm] || (ns == sessions[nm] && nu < used[nm])) {
                sessions[nm] = ns;
                used[nm] = nu;
            }
        }
    }
    int ans = sessions[full];
    free(sessions);
    free(used);
    return ans;
}
