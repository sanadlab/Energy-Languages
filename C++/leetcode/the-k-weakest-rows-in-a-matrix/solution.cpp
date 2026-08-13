class Solution {
public:
    vector<int> kWeakestRows(vector<vector<int>>& mat, int k) {
        vector<pair<int,int>> rows;
        for (int i = 0; i < (int)mat.size(); i++) {
            int c = 0;
            for (int v : mat[i]) if (v == 1) c++;
            rows.push_back({c, i});
        }
        sort(rows.begin(), rows.end());
        vector<int> res;
        int lim = min(k, (int)rows.size());
        for (int i = 0; i < lim; i++) res.push_back(rows[i].second);
        return res;
    }
};
