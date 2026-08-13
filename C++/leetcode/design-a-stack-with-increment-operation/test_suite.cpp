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
    CustomStack s(5);
    s.push(1); s.push(2); s.push(3);
    s.increment(2, 100);
    int r1 = s.pop();
    int r2 = s.pop();
    if (r1 < 0 && r2 < 0) return 1;
    return 0;
}
