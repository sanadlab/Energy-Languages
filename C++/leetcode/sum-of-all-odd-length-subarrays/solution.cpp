class Solution {
public:
    int sumOddLengthSubarrays(vector<int>& arr) {
        long long total = 0;
        int n = arr.size();
        for (int i = 0; i < n; i++) {
            long long count = ((long long)(i + 1) * (n - i) + 1) / 2;
            total += count * arr[i];
        }
        return (int)total;
    }
};
