class Solution {
public:
    int minStartValue(vector<int>& nums) {
        int prefix = 0, minPrefix = 0;
        for (int x : nums) {
            prefix += x;
            if (prefix < minPrefix) minPrefix = prefix;
        }
        int cand = 1 - minPrefix;
        return cand > 1 ? cand : 1;
    }
};
