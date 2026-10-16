import java.util.*;
import java.util.stream.*;
import java.math.*;

class Solution {
    public String evaluate(String s, List<List<String>> knowledge) {
        Map<String, String> value = new HashMap<>();
        for (List<String> kv : knowledge) value.put(kv.get(0), kv.get(1));
        StringBuilder out = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '(') {
                int j = s.indexOf(')', i);
                out.append(value.getOrDefault(s.substring(i + 1, j), "?"));
                i = j;
            } else {
                out.append(c);
            }
        }
        return out.toString();
    }
}
