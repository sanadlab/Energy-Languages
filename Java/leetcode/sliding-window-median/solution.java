import java.util.*;

class Solution {
    public double[] medianSlidingWindow(int[] nums, int k) {
        int n = nums.length;
        List<Double> res = new ArrayList<>();
        for (int i = 0; i + k <= n; i++) {
            int[] w = Arrays.copyOfRange(nums, i, i + k);
            Arrays.sort(w);
            double median;
            if (k % 2 == 1) median = w[k / 2];
            else median = ((double) w[k/2 - 1] + (double) w[k/2]) / 2.0;
            res.add(median);
        }
        double[] out = new double[res.size()];
        for (int i = 0; i < res.size(); i++) out[i] = res.get(i);
        return out;
    }
}
