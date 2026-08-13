class Solution {
public:
    vector<int> findKDistantIndices(vector<int>& nums, int key, int k) {
        int n = nums.size();
        vector<bool> is_valid(n, false);
        
        for (int j = 0; j < n; j++) {
            if (nums[j] == key) {
                int low = max(0, j - k);
                int high = min(n - 1, j + k);
                for (int i = low; i <= high; i++) {
                    is_valid[i] = true;
                }
            }
        }
        
        vector<int> result;
        for (int i = 0; i < n; i++) {
            if (is_valid[i]) {
                result.push_back(i);
            }
        }
        return result;
    }
};