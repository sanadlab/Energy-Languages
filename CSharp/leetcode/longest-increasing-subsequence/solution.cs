public class Solution {
    public int LengthOfLIS(int[] nums) {
        var tails = new List<int>();
        foreach (var x in nums) {
            int lo = 0, hi = tails.Count;
            while (lo < hi) {
                int mid = (lo + hi) / 2;
                if (tails[mid] < x) lo = mid + 1;
                else hi = mid;
            }
            if (lo == tails.Count) tails.Add(x);
            else tails[lo] = x;
        }
        return tails.Count;
    }
}
