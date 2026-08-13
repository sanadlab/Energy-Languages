public class Solution {
    bool Valid(string st) {
        int cnt = 0;
        foreach (char ch in st) {
            if (ch == '(') cnt++;
            else if (ch == ')') { cnt--; if (cnt < 0) return false; }
        }
        return cnt == 0;
    }
    public IList<string> RemoveInvalidParentheses(string s) {
        var level = new HashSet<string>{s};
        while (level.Count > 0) {
            var valids = new List<string>();
            foreach (var st in level) if (Valid(st)) valids.Add(st);
            if (valids.Count > 0) return valids;
            var nxt = new HashSet<string>();
            foreach (var st in level) {
                for (int i = 0; i < st.Length; i++) {
                    if (st[i] == '(' || st[i] == ')') {
                        nxt.Add(st.Substring(0, i) + st.Substring(i + 1));
                    }
                }
            }
            level = nxt;
        }
        return new List<string>{""};
    }
}
