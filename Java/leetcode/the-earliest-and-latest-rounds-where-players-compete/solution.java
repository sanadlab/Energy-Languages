import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

class Solution {
    private final Map<Long, int[]> memo = new HashMap<>();

    public int[] earliestAndLatest(int n, int firstPlayer, int secondPlayer) {
        return dp(n, firstPlayer, secondPlayer);
    }

    private int[] dp(int m, int f, int s) {
        if (f > s) {
            int t = f;
            f = s;
            s = t;
        }
        long key = ((long) m << 20) | ((long) f << 10) | s;
        int[] cached = memo.get(key);
        if (cached != null) {
            return cached;
        }
        int[] res;
        // The two players meet this round iff they are paired together.
        if (f + s == m + 1) {
            res = new int[]{1, 1};
            memo.put(key, res);
            return res;
        }
        int newM = (m + 1) / 2;

        // Build the list of matches; each match yields a set of possible winner positions.
        java.util.List<int[]> groups = new java.util.ArrayList<>();
        for (int p = 1; p <= m / 2; p++) {
            int q = m + 1 - p;
            if (f == p || f == q) {
                groups.add(new int[]{f});               // firstPlayer always wins
            } else if (s == p || s == q) {
                groups.add(new int[]{s});               // secondPlayer always wins
            } else {
                groups.add(new int[]{p, q});            // either side may win
            }
        }
        if (m % 2 == 1) {
            groups.add(new int[]{(m + 1) / 2});          // middle player auto-advances
        }

        // Enumerate every combination of winners, recording resulting (newF, newS).
        Set<Long> outcomes = new HashSet<>();
        enumerate(groups, 0, f, s, 0, 0, outcomes);

        int earliest = Integer.MAX_VALUE;
        int latest = Integer.MIN_VALUE;
        for (long packed : outcomes) {
            int nf = (int) (packed >> 20);
            int ns = (int) (packed & 0xFFFFF);
            int[] sub = dp(newM, nf, ns);
            earliest = Math.min(earliest, sub[0] + 1);
            latest = Math.max(latest, sub[1] + 1);
        }
        res = new int[]{earliest, latest};
        memo.put(key, res);
        return res;
    }

    private void enumerate(java.util.List<int[]> groups, int idx, int f, int s,
                           int belowF, int belowS, Set<Long> outcomes) {
        if (idx == groups.size()) {
            int nf = belowF + 1;
            int ns = belowS + 1;
            outcomes.add(((long) nf << 20) | ns);
            return;
        }
        for (int w : groups.get(idx)) {
            enumerate(groups, idx + 1, f, s,
                    belowF + (w < f ? 1 : 0),
                    belowS + (w < s ? 1 : 0),
                    outcomes);
        }
    }
}
