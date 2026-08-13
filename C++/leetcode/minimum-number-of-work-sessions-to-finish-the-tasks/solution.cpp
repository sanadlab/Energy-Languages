class Solution {
public:
    int minSessions(vector<int>& tasks, int sessionTime) {
        int n = tasks.size();
        int full = (1 << n) - 1;
        const int INF = 1e9;
        vector<int> sessions(1 << n, INF), used(1 << n, 0);
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
        return sessions[full];
    }
};
