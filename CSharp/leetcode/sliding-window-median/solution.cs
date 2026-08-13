public class Solution {
    public double[] MedianSlidingWindow(int[] nums, int k) {
        var res = new List<double>();
        int n = nums.Length;
        for (int i = 0; i + k <= n; i++) {
            int[] w = new int[k];
            Array.Copy(nums, i, w, 0, k);
            Array.Sort(w);
            double median;
            if (k % 2 == 1) median = w[k / 2];
            else median = ((double)w[k/2 - 1] + (double)w[k/2]) / 2.0;
            res.Add(median);
        }
        return res.ToArray();
    }
}
