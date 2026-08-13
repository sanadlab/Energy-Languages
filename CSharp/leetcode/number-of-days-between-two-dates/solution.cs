public class Solution {
    private long DaysFromCivil(long y, long m, long d) {
        y -= (m <= 2) ? 1 : 0;
        long era = (y >= 0 ? y : y - 399) / 400;
        long yoe = y - era * 400;
        long doy = (153 * (m + (m > 2 ? -3 : 9)) + 2) / 5 + d - 1;
        long doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
        return era * 146097 + doe - 719468;
    }

    private long[] Parse(string s) {
        long[] vals = new long[3];
        string[] parts = s.Split('-');
        for (int i = 0; i < 3 && i < parts.Length; i++) {
            long v;
            long.TryParse(parts[i], out v);
            vals[i] = v;
        }
        return vals;
    }

    public int DaysBetweenDates(string date1, string date2) {
        long[] p1 = Parse(date1);
        long[] p2 = Parse(date2);
        long a = DaysFromCivil(p1[0], p1[1], p1[2]);
        long b = DaysFromCivil(p2[0], p2[1], p2[2]);
        return (int)Math.Abs(a - b);
    }
}
