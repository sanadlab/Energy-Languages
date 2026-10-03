class Solution {
  List<int> nextGreaterElements(List<int> nums) {
    int n = nums.length;
    List<int> res = List<int>.filled(n, -1);
    List<int> st = [];
    for (int i = 0; i < 2 * n; i++) {
      int cur = nums[i % n];
      while (st.isNotEmpty && nums[st.last] < cur) {
        res[st.removeLast()] = cur;
      }
      if (i < n) st.add(i);
    }
    return res;
  }
}
