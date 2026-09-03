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
// LeetCode provides these helper types; define them for the arena compile.
struct TreeNode { int val; TreeNode *left; TreeNode *right; TreeNode():val(0),left(nullptr),right(nullptr){} TreeNode(int x):val(x),left(nullptr),right(nullptr){} TreeNode(int x,TreeNode*l,TreeNode*r):val(x),left(l),right(r){} };
#include "solution.cpp"

int main() { return 0; }
