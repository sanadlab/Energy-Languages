public class Solution {
    private int m, k;
    private List<int> stream = new List<int>();

    public Solution() { m = 0; k = 0; }
    public Solution(int m, int k) { this.m = m; this.k = k; }

    public void AddElement(int num) {
        stream.Add(num);
    }

    public int CalculateMKAverage() {
        int n = stream.Count;
        if (n < m) return -1;
        var last = stream.GetRange(n - m, m);
        last.Sort();
        long sum = 0;
        int cnt = 0;
        for (int i = k; i < m - k; i++) {
            sum += last[i];
            cnt++;
        }
        if (cnt == 0) return 0;
        return (int)(sum / cnt);
    }
}
