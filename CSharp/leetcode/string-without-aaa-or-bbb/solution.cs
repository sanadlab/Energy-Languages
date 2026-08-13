public class Solution {
    public string StrWithout3a3b(int a, int b) {
        var res = new List<char>();
        while (a > 0 || b > 0) {
            bool writeA;
            int n = res.Count;
            if (n >= 2 && res[n-1] == res[n-2]) writeA = (res[n-1] == 'b');
            else writeA = (a >= b);
            if (writeA) {
                if (a == 0) break;
                res.Add('a'); a--;
            } else {
                if (b == 0) break;
                res.Add('b'); b--;
            }
        }
        return new string(res.ToArray());
    }
}
