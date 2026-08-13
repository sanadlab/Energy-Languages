using System;
using System.Collections.Generic;

public class Solution {
    public IList<int> FindKDistantIndices(int[] nums, int key, int k) {
        int n = nums.Length;
        bool[] isKDistant = new bool[n];
        
        for (int j = 0; j < n; j++) {
            if (nums[j] == key) {
                int start = Math.Max(0, j - k);
                int end = Math.Min(n - 1, j + k);
                for (int i = start; i <= end; i++) {
                    isKDistant[i] = true;
                }
            }
        }
        
        List<int> result = new List<int>();
        for (int i = 0; i < n; i++) {
            if (isKDistant[i]) {
                result.Add(i);
            }
        }
        
        return result;
    }
}