#include <vector>
#include <unordered_map>
#include <unordered_set>
using namespace std;

class Solution {
public:
    bool canCross(vector<int>& stones) {
        int n = stones.size();
        // Map stone position to its index for quick lookup
        unordered_map<int, int> stoneIndex;
        for (int i = 0; i < n; ++i) {
            stoneIndex[stones[i]] = i;
        }
        
        // dp[i] stores the set of jump sizes that can land on stone i
        vector<unordered_set<int>> dp(n);
        dp[0].insert(0); // starting point, last jump size 0
        
        for (int i = 0; i < n; ++i) {
            for (int k : dp[i]) {
                for (int step = k - 1; step <= k + 1; ++step) {
                    if (step > 0) {
                        int nextPos = stones[i] + step;
                        if (stoneIndex.count(nextPos)) {
                            dp[stoneIndex[nextPos]].insert(step);
                        }
                    }
                }
            }
        }
        
        return !dp[n - 1].empty();
    }
};