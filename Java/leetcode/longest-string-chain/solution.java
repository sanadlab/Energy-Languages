import java.util.*;

class Solution {
    public int longestStrChain(String[] words) {
        Arrays.sort(words, (a, b) -> a.length() - b.length());
        Map<String, Integer> dp = new HashMap<>();
        int best = 1;
        for (String w : words) {
            int cur = 1;
            for (int i = 0; i < w.length(); i++) {
                String pred = w.substring(0, i) + w.substring(i + 1);
                if (dp.containsKey(pred)) cur = Math.max(cur, dp.get(pred) + 1);
            }
            dp.put(w, cur);
            best = Math.max(best, cur);
        }
        return best;
    }
}
