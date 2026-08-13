import java.util.*;

class Solution {
    boolean valid(String st) {
        int cnt = 0;
        for (int i = 0; i < st.length(); i++) {
            char ch = st.charAt(i);
            if (ch == '(') cnt++;
            else if (ch == ')') { cnt--; if (cnt < 0) return false; }
        }
        return cnt == 0;
    }
    public List<String> removeInvalidParentheses(String s) {
        Set<String> level = new HashSet<>();
        level.add(s);
        while (!level.isEmpty()) {
            List<String> valids = new ArrayList<>();
            for (String st : level) if (valid(st)) valids.add(st);
            if (!valids.isEmpty()) return valids;
            Set<String> nxt = new HashSet<>();
            for (String st : level) {
                for (int i = 0; i < st.length(); i++) {
                    char ch = st.charAt(i);
                    if (ch == '(' || ch == ')') {
                        nxt.add(st.substring(0, i) + st.substring(i + 1));
                    }
                }
            }
            level = nxt;
        }
        return new ArrayList<>(Collections.singletonList(""));
    }
}
