public class Solution {
    public int NextBeautifulNumber(int n) {
        for (int x = n + 1; ; x++) {
            int[] cnt = new int[10];
            int t = x;
            while (t > 0) { cnt[t % 10]++; t /= 10; }
            bool ok = true;
            for (int d = 0; d < 10; d++) {
                if (cnt[d] != 0 && cnt[d] != d) { ok = false; break; }
            }
            if (ok) return x;
        }
    }
}
