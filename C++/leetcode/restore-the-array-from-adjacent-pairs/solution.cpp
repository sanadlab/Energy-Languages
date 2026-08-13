class Solution {
public:
    vector<int> restoreArray(vector<vector<int>>& adjacentPairs) {
        unordered_map<int, vector<int>> adj;
        for (auto& p : adjacentPairs) {
            adj[p[0]].push_back(p[1]);
            adj[p[1]].push_back(p[0]);
        }
        int n = (int)adjacentPairs.size() + 1;
        int start = adjacentPairs.empty() ? 0 : adjacentPairs[0][0];
        for (auto& e : adj) {
            if (e.second.size() == 1) { start = e.first; break; }
        }
        vector<int> res;
        res.push_back(start);
        int prev = start, cur = start;
        bool hasPrev = false;
        while ((int)res.size() < n) {
            int nxt = 0; bool found = false;
            auto it = adj.find(cur);
            if (it != adj.end()) {
                for (int x : it->second) {
                    if (!hasPrev || x != prev) { nxt = x; found = true; break; }
                }
            }
            if (!found) break;
            res.push_back(nxt);
            prev = cur; hasPrev = true; cur = nxt;
        }
        return res;
    }
};
