// LC-energy test suite (C++) — hardcoded single case.
#include "solution.cpp"
#include <vector>
#include <string>
int main() {
    Solution sol;
    auto result = sol.kWeakestRows(std::vector<std::vector<int>>{{1,2},{3,4}}, 20);
    (void)result;
    return 0;
}
