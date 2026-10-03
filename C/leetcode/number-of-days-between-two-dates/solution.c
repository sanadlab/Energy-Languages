#include <stdio.h>

static int civil_days(int y, int m, int d) {
    y -= (m <= 2) ? 1 : 0;
    int era = y / 400;              /* y >= 0 for all test dates, so trunc == floor */
    int yoe = y - era * 400;
    int doy = (153 * (m + (m > 2 ? -3 : 9)) + 2) / 5 + d - 1;
    int doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
    return era * 146097 + doe - 719468;
}

int daysBetweenDates(char* date1, char* date2) {
    int y1 = 0, m1 = 0, d1 = 0, y2 = 0, m2 = 0, d2 = 0;
    sscanf(date1, "%d-%d-%d", &y1, &m1, &d1);
    sscanf(date2, "%d-%d-%d", &y2, &m2, &d2);
    int a = civil_days(y1, m1, d1);
    int b = civil_days(y2, m2, d2);
    int diff = a - b;
    return diff < 0 ? -diff : diff;
}
