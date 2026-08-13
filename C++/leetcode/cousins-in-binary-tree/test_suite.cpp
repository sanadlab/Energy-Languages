// Prelude injected for LC-energy — pulls in the STL bits LC's judge
// implicitly provides, so accepted-solution snippets that call things
// like `unordered_map` or `sort` without an explicit include still
// compile.
#include <algorithm>
#include <climits>
#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <deque>
#include <functional>
#include <iostream>
#include <map>
#include <numeric>
#include <queue>
#include <set>
#include <sstream>
#include <stack>
#include <string>
#include <tuple>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>
using namespace std;

// LC-energy test suite (C++) — cousins-in-binary-tree.
// TreeNode is defined in solution.cpp; we include and use it here.
#include "solution.cpp"

int main() {
    auto* root = new TreeNode(1);
    root->left  = new TreeNode(2); root->left->right  = new TreeNode(4);
    root->right = new TreeNode(3); root->right->right = new TreeNode(5);
    Solution s;
    auto __lc_a0 = root;
    auto __lc_a1 = 4;
    auto __lc_a2 = 5;
    bool r = s.isCousins(__lc_a0, __lc_a1, __lc_a2);
    if (!r) return 1;
    return 0;
}
