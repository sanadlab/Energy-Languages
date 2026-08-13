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

// LC-energy test suite (C++) — hardcoded single case.
#include "solution.cpp"
#include <vector>
#include <string>
int main() {
    Solution sol;
    auto __lc_a0 = 20;
    auto __lc_a1 = std::vector<std::vector<int>>{{1,2},{3,4}};
    auto __lc_a2 = std::vector<std::vector<int>>{{1,2},{3,4}};
    auto result = sol.friendRequests(__lc_a0, __lc_a1, __lc_a2);
    (void)result;
    return 0;
}
