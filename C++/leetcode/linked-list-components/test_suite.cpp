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

// LC-energy test suite (C++) — linked-list-components.
#include "solution.cpp"

int main() {
    auto* h = new ListNode(0);
    h->next = new ListNode(1);
    h->next->next = new ListNode(2);
    h->next->next->next = new ListNode(3);
    std::vector<int> nums{0, 1, 3};
    Solution s;
    int r = s.numComponents(h, nums);
    if (r < 0) return 1;
    return 0;
}
