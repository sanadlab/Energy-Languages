public class Solution {
    public int LongestStrChain(string[] words) {
        Array.Sort(words, (a, b) => a.Length - b.Length);
        var dp = new Dictionary<string, int>();
        int best = 1;
        foreach (var w in words) {
            int cur = 1;
            for (int i = 0; i < w.Length; i++) {
                string pred = w.Substring(0, i) + w.Substring(i + 1);
                if (dp.TryGetValue(pred, out int v)) cur = Math.Max(cur, v + 1);
            }
            dp[w] = cur;
            best = Math.Max(best, cur);
        }
        return best;
    }
}
