class Solution {
public:
    vector<int> eventualSafeNodes(vector<vector<int>>& graph) {
        int n = graph.size();
        vector<vector<int>> rev(n);
        vector<int> outdeg(n, 0);
        for (int u = 0; u < n; u++) {
            for (int v : graph[u]) {
                if (v >= 0 && v < n) {
                    rev[v].push_back(u);
                    outdeg[u]++;
                }
            }
        }
        queue<int> q;
        for (int i = 0; i < n; i++) if (outdeg[i] == 0) q.push(i);
        vector<bool> safe(n, false);
        while (!q.empty()) {
            int v = q.front(); q.pop();
            safe[v] = true;
            for (int u : rev[v]) {
                if (--outdeg[u] == 0) q.push(u);
            }
        }
        vector<int> res;
        for (int i = 0; i < n; i++) if (safe[i]) res.push_back(i);
        return res;
    }
};
