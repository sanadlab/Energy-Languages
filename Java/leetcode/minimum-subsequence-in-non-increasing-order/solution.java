import java.util.*;

class Solution {
    public List<Integer> minSubsequence(int[] nums) {
        Integer[] arr = new Integer[nums.length];
        for (int i = 0; i < nums.length; i++) arr[i] = nums[i];
        Arrays.sort(arr, Collections.reverseOrder());
        long total = 0;
        for (int x : arr) total += x;
        long running = 0;
        List<Integer> res = new ArrayList<>();
        for (int x : arr) {
            running += x;
            res.add(x);
            if (running * 2 > total) break;
        }
        return res;
    }
}
