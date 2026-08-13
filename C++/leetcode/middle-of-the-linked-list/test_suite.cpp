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

// LC-energy test suite (C++) — middle-of-the-linked-list.
#include <initializer_list>
#include "solution.cpp"

int main() {
    auto* h = new ListNode(1); auto* c = h;
    for (int v : std::initializer_list<int>{2, 3, 4, 5}) { c->next = new ListNode(v); c = c->next; }
    Solution s;
    auto* r = s.middleNode(h);
    if (!r) return 1;
    return 0;
}
