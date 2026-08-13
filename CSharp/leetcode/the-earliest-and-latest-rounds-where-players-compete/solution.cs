public class Solution {
    Dictionary<int, (int, int)> memo = new Dictionary<int, (int, int)>();
    (int, int) Dp(int n, int f, int s) {
        if (f + s == n + 1) return (1, 1);
        if (f + s > n + 1) { int t = f; f = n + 1 - s; s = n + 1 - t; }
        int key = (n * 100 + f) * 100 + s;
        if (memo.TryGetValue(key, out var v)) return v;
        int half = (n + 1) / 2;
        const int INF = 1 << 30;
        int earliest = INF, latest = -INF;
        if (s <= half) {
            for (int i = 0; i < f; i++)
                for (int j = 0; j < s - f; j++) {
                    var r = Dp(half, i + 1, i + j + 2);
                    earliest = Math.Min(earliest, r.Item1);
                    latest = Math.Max(latest, r.Item2);
                }
        } else {
            int sp = n + 1 - s;
            int mid = n / 2;
            for (int i = 0; i < f; i++)
                for (int j = 0; j < sp - f; j++) {
                    var r = Dp(half, i + 1, i + (mid - sp) + j + 2);
                    earliest = Math.Min(earliest, r.Item1);
                    latest = Math.Max(latest, r.Item2);
                }
        }
        var res = (earliest + 1, latest + 1);
        memo[key] = res;
        return res;
    }
    public int[] EarliestAndLatest(int n, int firstPlayer, int secondPlayer) {
        if (firstPlayer == secondPlayer) return new int[]{1, 1};
        if (firstPlayer > secondPlayer) { int t = firstPlayer; firstPlayer = secondPlayer; secondPlayer = t; }
        var r = Dp(n, firstPlayer, secondPlayer);
        return new int[]{r.Item1, r.Item2};
    }
}
