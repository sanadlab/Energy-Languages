import java.util.*;

class Solution {
    private Map<Integer, Integer> memo = new HashMap<>();
    public int minDays(int n) {
        if (n <= 1) return n;
        if (memo.containsKey(n)) return memo.get(n);
        int res = 1 + Math.min(n % 2 + minDays(n / 2), n % 3 + minDays(n / 3));
        memo.put(n, res);
        return res;
    }
}
