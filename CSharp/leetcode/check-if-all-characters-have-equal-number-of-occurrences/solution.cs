public class Solution {
    public bool AreOccurrencesEqual(string s) {
        var cnt = new Dictionary<char, int>();
        foreach (char c in s) {
            if (!cnt.ContainsKey(c)) cnt[c] = 0;
            cnt[c]++;
        }
        int first = cnt.Values.First();
        return cnt.Values.All(v => v == first);
    }
}
