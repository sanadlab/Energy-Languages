public class Solution {
    public int MaxEqualFreq(int[] nums) {
        int n = nums.Length;
        int[] count = new int[100001];
        int[] freq = new int[n + 1];
        int maxF = 0, res = 0;
        for (int i = 0; i < n; i++) {
            int v = nums[i];
            if (count[v] > 0) freq[count[v]]--;
            count[v]++;
            freq[count[v]]++;
            if (count[v] > maxF) maxF = count[v];
            if (maxF == 1 ||
                (long)freq[maxF] * maxF == i ||
                (freq[maxF] == 1 && (long)(maxF - 1) * (freq[maxF - 1] + 1) == i)) {
                res = i + 1;
            }
        }
        return res;
    }
}
