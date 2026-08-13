class Solution {
public:
    int minNumberOperations(vector<int>& target) {
        if (target.empty()) return 0;
        long ans = target[0];
        for (size_t i = 1; i < target.size(); i++) {
            if (target[i] > target[i-1]) ans += target[i] - target[i-1];
        }
        return (int)ans;
    }
};
