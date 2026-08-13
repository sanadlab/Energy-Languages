public class Solution {
    public int[] NumSmallerByFrequency(string[] queries, string[] words) {
        var wf = words.Select(F).OrderBy(x => x).ToArray();
        return queries.Select(q => {
            int fq = F(q);
            return wf.Count(v => v > fq);
        }).ToArray();
    }
    private int F(string s) {
        char mn = 'z';
        int cnt = 0;
        foreach (char c in s) {
            if (c < mn) { mn = c; cnt = 1; }
            else if (c == mn) cnt++;
        }
        return cnt;
    }
}
