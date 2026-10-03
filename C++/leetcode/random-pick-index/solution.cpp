#include <vector>
#include <cstdlib>
using namespace std;

class Solution {
public:
    vector<int> nums;

    Solution(vector<int>& nums) {
        this->nums = nums;
    }

    int pick(int target) {
        // Reservoir sampling: uniformly random index among positions whose
        // value equals target, O(1) extra space.
        int count = 0, res = -1;
        for (int i = 0; i < (int)nums.size(); i++) {
            if (nums[i] == target) {
                count++;
                if (rand() % count == 0) res = i;
            }
        }
        return res;
    }
};
