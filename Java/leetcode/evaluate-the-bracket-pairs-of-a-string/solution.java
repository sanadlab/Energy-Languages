import java.util.HashMap;
import java.util.Map;

class Solution {
    public String evaluate(String s, String[][] knowledge) {
        Map<String, String> map = new HashMap<>();
        
        // Populate the map with key-value pairs from knowledge array
        for (String[] pair : knowledge) {
            map.put(pair[0], pair[1]);
        }
        
        StringBuilder result = new StringBuilder();
        boolean inBracket = false;
        StringBuilder keyBuilder = new StringBuilder();
        
        for (char c : s.toCharArray()) {
            if (c == '(') {
                inBracket = true;
                continue;
            } else if (c == ')') {
                inBracket = false;
                String value = map.get(keyBuilder.toString());
                result.append(value != null ? value : "?");
                keyBuilder.setLength(0); // Reset the key builder
            } else if (inBracket) {
                keyBuilder.append(c);
            } else {
                result.append(c);
            }
        }
        
        return result.toString();
    }
}