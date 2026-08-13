public class Solution {
    private Dictionary<long, int> memo = new Dictionary<long, int>();
    public int MinDays(int n) {
        return Solve((long)n);
    }
    private int Solve(long n) {
        if (n <= 1) return (int)n;
        if (memo.ContainsKey(n)) return memo[n];
        int a = (int)(n % 2) + Solve(n / 2);
        int b = (int)(n % 3) + Solve(n / 3);
        int res = 1 + Math.Min(a, b);
        memo[n] = res;
        return res;
    }
}
