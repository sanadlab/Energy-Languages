public class Solution {
    public IList<string> AmbiguousCoordinates(string s) {
        string digits = s.Substring(1, s.Length - 2);
        int n = digits.Length;
        var res = new List<string>();
        for (int i = 1; i < n; i++) {
            var left = Make(digits.Substring(0, i));
            var right = Make(digits.Substring(i));
            foreach (var a in left)
                foreach (var b in right)
                    res.Add("(" + a + ", " + b + ")");
        }
        return res;
    }

    private List<string> Make(string d) {
        var outList = new List<string>();
        int n = d.Length;
        if (n == 1) {
            outList.Add(d);
            return outList;
        }
        if (d[0] != '0') outList.Add(d);
        for (int i = 1; i < n; i++) {
            string l = d.Substring(0, i);
            string r = d.Substring(i);
            if ((l == "0" || l[0] != '0') && r[r.Length - 1] != '0')
                outList.Add(l + "." + r);
        }
        return outList;
    }
}
