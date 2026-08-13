class Solution {
public:
    long daysFromCivil(long y, long m, long d) {
        y -= (m <= 2) ? 1 : 0;
        long era = (y >= 0 ? y : y - 399) / 400;
        long yoe = y - era * 400;
        long doy = (153 * (m + (m > 2 ? -3 : 9)) + 2) / 5 + d - 1;
        long doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
        return era * 146097 + doe - 719468;
    }

    void parse(const string& s, long& y, long& m, long& d) {
        long vals[3] = {0, 0, 0};
        int idx = 0;
        long cur = 0;
        for (char c : s) {
            if (c >= '0' && c <= '9') {
                cur = cur * 10 + (c - '0');
            } else {
                if (idx < 3) vals[idx] = cur;
                idx++;
                cur = 0;
            }
        }
        if (idx < 3) vals[idx] = cur;
        y = vals[0]; m = vals[1]; d = vals[2];
    }

    int daysBetweenDates(string date1, string date2) {
        long y1, m1, d1, y2, m2, d2;
        parse(date1, y1, m1, d1);
        parse(date2, y2, m2, d2);
        long a = daysFromCivil(y1, m1, d1);
        long b = daysFromCivil(y2, m2, d2);
        long diff = a - b;
        if (diff < 0) diff = -diff;
        return (int)diff;
    }
};
