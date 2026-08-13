#include <vector>
#include <algorithm>
#include <numeric>
using namespace std;

class Solution {
public:
    vector<int> ans;
    vector<vector<int>> g;
    vector<int> nums;
    // For each value from 1 to 50, store a stack of pairs (node, depth)
    vector<vector<pair<int,int>>> valStack;
    
    void dfs(int u, int parent, int depth) {
        int bestDepth = -1;
        int bestNode = -1;
        int curVal = nums[u];
        
        // Check all values 1..50 for coprimality with curVal
        for (int v = 1; v <= 50; ++v) {
            if (!valStack[v].empty() && gcd(curVal, v) == 1) {
                auto &stk = valStack[v];
                auto [node, d] = stk.back();
                if (d > bestDepth) {
                    bestDepth = d;
                    bestNode = node;
                }
            }
        }
        ans[u] = bestNode;
        
        // Push current node with its value
        valStack[curVal].emplace_back(u, depth);
        
        for (int w : g[u]) {
            if (w != parent) {
                dfs(w, u, depth + 1);
            }
        }
        
        valStack[curVal].pop_back();
    }
    
    vector<int> getCoprimes(vector<int>& nums_, vector<vector<int>>& edges) {
        int n = (int)nums_.size();
        nums = nums_;
        g.assign(n, vector<int>());
        for (auto &e : edges) {
            g[e[0]].push_back(e[1]);
            g[e[1]].push_back(e[0]);
        }
        ans.assign(n, -1);
        valStack.assign(51, vector<pair<int,int>>());
        
        dfs(0, -1, 0);
        return ans;
    }
};