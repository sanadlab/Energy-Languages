import java.util.*;

class Solution {
    public List<String> ambiguousCoordinates(String s) {
        String digits = s.substring(1, s.length() - 1);
        int n = digits.length();
        List<String> res = new ArrayList<>();
        for (int i = 1; i < n; i++) {
            List<String> left = make(digits.substring(0, i));
            List<String> right = make(digits.substring(i));
            for (String a : left)
                for (String b : right)
                    res.add("(" + a + ", " + b + ")");
        }
        return res;
    }

    private List<String> make(String d) {
        List<String> out = new ArrayList<>();
        int n = d.length();
        if (n == 1) {
            out.add(d);
            return out;
        }
        if (d.charAt(0) != '0') out.add(d);
        for (int i = 1; i < n; i++) {
            String l = d.substring(0, i);
            String r = d.substring(i);
            if ((l.equals("0") || l.charAt(0) != '0') && r.charAt(r.length() - 1) != '0')
                out.add(l + "." + r);
        }
        return out;
    }
}
