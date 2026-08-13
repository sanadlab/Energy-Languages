class Solution {
public:
    vector<double> medianSlidingWindow(vector<int>& nums, int k) {
        vector<double> res;
        int n = nums.size();
        for (int i = 0; i + k <= n; i++) {
            vector<int> w(nums.begin() + i, nums.begin() + i + k);
            sort(w.begin(), w.end());
            double median;
            if (k % 2 == 1) median = w[k / 2];
            else median = ((double)w[k/2 - 1] + (double)w[k/2]) / 2.0;
            res.push_back(median);
        }
        return res;
    }
};
