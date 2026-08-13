import java.util.*;
class Solution {
    public String[] uncommonFromSentences(String s1, String s2) {
        Map<String,Integer> cnt = new HashMap<>();
        for (String w : (s1 + " " + s2).split(" ")) {
            if (w.isEmpty()) continue;
            cnt.merge(w, 1, Integer::sum);
        }
        List<String> res = new ArrayList<>();
        for (Map.Entry<String,Integer> e : cnt.entrySet())
            if (e.getValue() == 1) res.add(e.getKey());
        return res.toArray(new String[0]);
    }
}
