class Solution {
public:
    unordered_map<long long, int> memo;
    int minDays(int n) {
        return solve((long long)n);
    }
    int solve(long long n) {
        if (n <= 1) return (int)n;
        if (memo.count(n)) return memo[n];
        int a = (int)(n % 2) + solve(n / 2);
        int b = (int)(n % 3) + solve(n / 3);
        int res = 1 + min(a, b);
        memo[n] = res;
        return res;
    }
};
