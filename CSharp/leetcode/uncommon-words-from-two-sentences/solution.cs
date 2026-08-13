public class Solution {
    public string[] UncommonFromSentences(string s1, string s2) {
        var cnt = new Dictionary<string,int>();
        foreach (var w in (s1 + " " + s2).Split(' ', StringSplitOptions.RemoveEmptyEntries))
            cnt[w] = cnt.GetValueOrDefault(w, 0) + 1;
        return cnt.Where(p => p.Value == 1).Select(p => p.Key).ToArray();
    }
}
