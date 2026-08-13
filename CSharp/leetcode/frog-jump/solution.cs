using System;
using System.Collections.Generic;

public class Solution {
    public bool CanCross(int[] stones) {
        int n = stones.Length;
        // Map stone position to its index for quick lookup
        Dictionary<int, int> stoneIndices = new Dictionary<int, int>();
        for (int i = 0; i < n; i++) {
            stoneIndices[stones[i]] = i;
        }
        
        // dp[i] stores a HashSet of jump sizes that can land on stone i
        HashSet<int>[] dp = new HashSet<int>[n];
        for (int i = 0; i < n; i++) {
            dp[i] = new HashSet<int>();
        }
        dp[0].Add(0); // Starting point, last jump size is 0
        
        for (int i = 0; i < n; i++) {
            foreach (int k in dp[i]) {
                for (int step = k - 1; step <= k + 1; step++) {
                    if (step > 0) {
                        int nextPos = stones[i] + step;
                        if (stoneIndices.ContainsKey(nextPos)) {
                            int nextIndex = stoneIndices[nextPos];
                            dp[nextIndex].Add(step);
                        }
                    }
                }
            }
        }
        
        return dp[n - 1].Count > 0;
    }
}