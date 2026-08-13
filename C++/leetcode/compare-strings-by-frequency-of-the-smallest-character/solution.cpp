class Solution {
public:
    vector<int> numSmallerByFrequency(vector<string>& queries, vector<string>& words) {
        vector<int> wf;
        for (auto& w : words) wf.push_back(f(w));
        sort(wf.begin(), wf.end());
        vector<int> ans;
        for (auto& q : queries) {
            int fq = f(q);
            int c = (int)(wf.end() - upper_bound(wf.begin(), wf.end(), fq));
            ans.push_back(c);
        }
        return ans;
    }
private:
    int f(const string& s) {
        char mn = 'z';
        int cnt = 0;
        for (char c : s) {
            if (c < mn) { mn = c; cnt = 1; }
            else if (c == mn) cnt++;
        }
        return cnt;
    }
};
