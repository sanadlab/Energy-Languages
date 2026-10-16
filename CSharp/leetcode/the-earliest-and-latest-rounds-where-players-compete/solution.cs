public class Solution {
    // Exact recursion over the positions of the two players: each round, every
    // other match may go either way, so enumerate how many winners finish ahead
    // of each player (only those counts matter for the next round).
    private readonly Dictionary<int, (int, int)> memo = new Dictionary<int, (int, int)>();

    private (int, int) Dp(int m, int f, int s) {
        if (f > s) (f, s) = (s, f);
        if (f + s == m + 1) return (1, 1);
        int key = m * 10000 + f * 100 + s;
        if (memo.TryGetValue(key, out var hit)) return hit;
        var states = new HashSet<int> { 0 };          // bf * 100 + bs
        void Step(int[] opts) {
            var next = new HashSet<int>();
            foreach (int st in states) {
                int bf = st / 100, bs = st % 100;
                foreach (int w in opts) next.Add((bf + (w < f ? 1 : 0)) * 100 + bs + (w < s ? 1 : 0));
            }
            states = next;
        }
        for (int p = 1; p <= m / 2; p++) {
            int q = m + 1 - p;
            if (p == f || q == f) Step(new[] { f });
            else if (p == s || q == s) Step(new[] { s });
            else Step(new[] { p, q });
        }
        if (m % 2 == 1) Step(new[] { (m + 1) / 2 });
        int earliest = int.MaxValue, latest = int.MinValue;
        foreach (int st in states) {
            var (e, l) = Dp((m + 1) / 2, st / 100 + 1, st % 100 + 1);
            earliest = Math.Min(earliest, e + 1);
            latest = Math.Max(latest, l + 1);
        }
        memo[key] = (earliest, latest);
        return (earliest, latest);
    }

    public int[] EarliestAndLatest(int n, int firstPlayer, int secondPlayer) {
        var (e, l) = Dp(n, firstPlayer, secondPlayer);
        return new[] { e, l };
    }
}
