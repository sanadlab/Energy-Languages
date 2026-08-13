import java.util.*;

class Solution {
    public String reformatDate(String date) {
        String[] mo = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
        Map<String,String> months = new HashMap<>();
        for (int i = 0; i < 12; i++) months.put(mo[i], String.format("%02d", i + 1));
        String[] parts = date.trim().split("\\s+");
        if (parts.length < 3) return "";
        String day = parts[0].length() >= 2 ? parts[0].substring(0, parts[0].length() - 2) : parts[0];
        if (day.length() == 1) day = "0" + day;
        String month = months.getOrDefault(parts[1], "01");
        return parts[2] + "-" + month + "-" + day;
    }
}
