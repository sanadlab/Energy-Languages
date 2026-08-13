class Solution {
public:
    vector<bool> friendRequests(int n, vector<vector<int>>& restrictions, vector<vector<int>>& requests) {
        parent.assign(n, 0);
        for (int i = 0; i < n; i++) parent[i] = i;
        vector<bool> res;
        for (auto& req : requests) {
            int u = req[0], v = req[1];
            int pu = find(u), pv = find(v);
            if (pu == pv) { res.push_back(true); continue; }
            bool ok = true;
            for (auto& r : restrictions) {
                int px = find(r[0]), py = find(r[1]);
                if ((px == pu && py == pv) || (px == pv && py == pu)) { ok = false; break; }
            }
            if (ok) { parent[pu] = pv; res.push_back(true); }
            else res.push_back(false);
        }
        return res;
    }

private:
    vector<int> parent;
    int find(int x) {
        while (parent[x] != x) { parent[x] = parent[parent[x]]; x = parent[x]; }
        return x;
    }
};
