class Solution {
public:
    long long helper(vector<int>& a, vector<int>& b) {
        long long cnt = 0;
        for (int x : a) {
            long long t = (long long)x * x;
            unordered_map<long long, long long> seen;
            for (int y : b) {
                if (t % y == 0) {
                    long long need = t / y;
                    auto it = seen.find(need);
                    if (it != seen.end()) cnt += it->second;
                }
                seen[y]++;
            }
        }
        return cnt;
    }
    int numTriplets(vector<int>& nums1, vector<int>& nums2) {
        return (int)(helper(nums1, nums2) + helper(nums2, nums1));
    }
};
