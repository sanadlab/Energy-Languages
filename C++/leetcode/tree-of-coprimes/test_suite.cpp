// LC-energy test suite (C++) — hardcoded single case.
#include "solution.cpp"
#include <vector>
#include <string>
int main() {
    Solution sol;
    auto result = sol.getCoprimes(std::vector<int>{1,2,3,4,5}, std::vector<std::vector<int>>{{1,2},{3,4}});
    (void)result;
    return 0;
}
