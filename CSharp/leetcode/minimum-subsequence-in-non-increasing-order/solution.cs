public class Solution {
    public IList<int> MinSubsequence(int[] nums) {
        Array.Sort(nums);
        Array.Reverse(nums);
        long total = 0;
        foreach (int x in nums) total += x;
        long running = 0;
        var res = new List<int>();
        foreach (int x in nums) {
            running += x;
            res.Add(x);
            if (running * 2 > total) break;
        }
        return res;
    }
}
