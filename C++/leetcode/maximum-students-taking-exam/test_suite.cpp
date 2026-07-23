// LC-energy test suite (C++) — hardcoded single case.
#include "solution.cpp"
#include <vector>
#include <string>
int main() {
    Solution sol;
    auto result = sol.maxStudents(std::vector<std::vector<char>>{{'a','b'},{'c','d'}});
    (void)result;
    return 0;
}
