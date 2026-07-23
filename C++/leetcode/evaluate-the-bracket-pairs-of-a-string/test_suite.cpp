// LC-energy test suite (C++) — hardcoded single case.
#include "solution.cpp"
#include <vector>
#include <string>
int main() {
    Solution sol;
    auto result = sol.evaluate("abcde", std::vector<std::vector<std::string>>{{"a","b"},{"c","d"}});
    (void)result;
    return 0;
}
