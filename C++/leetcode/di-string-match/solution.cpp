class Solution {
public:
    vector<int> diStringMatch(string s) {
        int n = s.size();
        int low = 0, high = n;
        vector<int> perm;
        for (char c : s) {
            if (c == 'I') {
                perm.push_back(low++);
            } else {
                perm.push_back(high--);
            }
        }
        perm.push_back(low); // low == high here
        return perm;
    }
};