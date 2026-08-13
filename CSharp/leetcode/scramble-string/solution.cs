using System;
using System.Collections.Generic;

public class Solution {
    private Dictionary<(string, string), bool> memo = new Dictionary<(string, string), bool>();
    
    public bool IsScramble(string s1, string s2) {
        if (s1 == s2) return true;
        if (s1.Length != s2.Length) return false;
        
        var key = (s1, s2);
        if (memo.ContainsKey(key)) return memo[key];
        
        // Quick check: if s1 and s2 have different character counts, return false
        int[] count = new int[26];
        for (int i = 0; i < s1.Length; i++) {
            count[s1[i] - 'a']++;
            count[s2[i] - 'a']--;
        }
        for (int i = 0; i < 26; i++) {
            if (count[i] != 0) {
                memo[key] = false;
                return false;
            }
        }
        
        int n = s1.Length;
        for (int i = 1; i < n; i++) {
            // Case 1: No swap
            if (IsScramble(s1.Substring(0, i), s2.Substring(0, i)) &&
                IsScramble(s1.Substring(i), s2.Substring(i))) {
                memo[key] = true;
                return true;
            }
            // Case 2: Swap
            if (IsScramble(s1.Substring(0, i), s2.Substring(n - i)) &&
                IsScramble(s1.Substring(i), s2.Substring(0, n - i))) {
                memo[key] = true;
                return true;
            }
        }
        
        memo[key] = false;
        return false;
    }
}