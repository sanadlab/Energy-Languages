public class Solution {
    public int[] NextGreaterElements(int[] nums) {
        int n = nums.Length;
        int[] res = new int[n];
        for (int i = 0; i < n; i++) res[i] = -1;
        var st = new Stack<int>();
        for (int i = 0; i < 2 * n; i++) {
            int cur = nums[i % n];
            while (st.Count > 0 && nums[st.Peek()] < cur) {
                res[st.Peek()] = cur;
                st.Pop();
            }
            if (i < n) st.Push(i);
        }
        return res;
    }
}
