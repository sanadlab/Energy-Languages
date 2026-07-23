// LC-energy test suite (C++) — hardcoded single case.
#include "solution.cpp"
#include <vector>
#include <string>
int main() {
    Solution sol;
    auto result = sol.ladderLength("abcde", "abcde", std::vector<std::string>{"a","b","c"});
    (void)result;
    return 0;
}
