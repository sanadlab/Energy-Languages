class Solution {
public:
    int maxEqualFreq(vector<int>& nums) {
        int n = nums.size();
        vector<int> count(100001, 0);
        vector<int> freq(n + 1, 0);
        int maxF = 0, res = 0;
        for (int i = 0; i < n; i++) {
            int v = nums[i];
            if (count[v] > 0) freq[count[v]]--;
            count[v]++;
            freq[count[v]]++;
            if (count[v] > maxF) maxF = count[v];
            if (maxF == 1 ||
                (long long)freq[maxF] * maxF == i ||
                (freq[maxF] == 1 && (long long)(maxF - 1) * (freq[maxF - 1] + 1) == i)) {
                res = i + 1;
            }
        }
        return res;
    }
};
