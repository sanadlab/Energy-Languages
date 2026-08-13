class Solution {
    public int daysBetweenDates(String date1, String date2) {
        int[] p1 = parse(date1);
        int[] p2 = parse(date2);
        long a = daysFromCivil(p1[0], p1[1], p1[2]);
        long b = daysFromCivil(p2[0], p2[1], p2[2]);
        return (int) Math.abs(a - b);
    }

    private int[] parse(String s) {
        int[] vals = new int[3];
        String[] parts = s.split("-");
        for (int i = 0; i < 3 && i < parts.length; i++) {
            try {
                vals[i] = Integer.parseInt(parts[i]);
            } catch (NumberFormatException e) {
                vals[i] = 0;
            }
        }
        return vals;
    }

    private long daysFromCivil(long y, long m, long d) {
        y -= (m <= 2) ? 1 : 0;
        long era = (y >= 0 ? y : y - 399) / 400;
        long yoe = y - era * 400;
        long doy = (153 * (m + (m > 2 ? -3 : 9)) + 2) / 5 + d - 1;
        long doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
        return era * 146097 + doe - 719468;
    }
}
