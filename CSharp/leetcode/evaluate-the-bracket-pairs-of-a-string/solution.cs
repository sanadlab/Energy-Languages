using System.Text;

public class Solution {
    public string Evaluate(string s, IList<IList<string>> knowledge) {
        var map = new Dictionary<string, string>();
        foreach (var pair in knowledge) {
            map[pair[0]] = pair[1];
        }
        var sb = new StringBuilder();
        int n = s.Length, idx = 0;
        while (idx < n) {
            if (s[idx] == '(') {
                int j = idx + 1;
                while (j < n && s[j] != ')') j++;
                string key = s.Substring(idx + 1, j - idx - 1);
                sb.Append(map.TryGetValue(key, out var val) ? val : "?");
                idx = j + 1;
            } else {
                sb.Append(s[idx]);
                idx++;
            }
        }
        return sb.ToString();
    }
}
