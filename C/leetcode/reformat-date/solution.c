#include <stdlib.h>
#include <string.h>
#include <stdio.h>

char* reformatDate(char* date) {
    static const char* names[12] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                     "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
    char d[32] = {0}, m[16] = {0}, y[16] = {0};
    int got = sscanf(date, "%31s %15s %15s", d, m, y);
    if (got < 3) {
        char* empty = malloc(1);
        empty[0] = '\0';
        return empty;
    }

    char day[34];
    int dl = (int)strlen(d);
    if (dl >= 2) {
        memcpy(day, d, dl - 2);
        day[dl - 2] = '\0';
    } else {
        strcpy(day, d);
    }
    if (strlen(day) == 1) {
        char tmp[34];
        tmp[0] = '0';
        strcpy(tmp + 1, day);
        strcpy(day, tmp);
    }

    char month[3] = "01";
    for (int i = 0; i < 12; i++) {
        if (strcmp(m, names[i]) == 0) {
            int mn = i + 1;
            month[0] = '0' + mn / 10;
            month[1] = '0' + mn % 10;
            month[2] = '\0';
            break;
        }
    }

    char* r = malloc(strlen(y) + strlen(day) + 8);
    sprintf(r, "%s-%s-%s", y, month, day);
    return r;
}
