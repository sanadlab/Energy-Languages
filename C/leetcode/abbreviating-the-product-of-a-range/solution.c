#include <stdlib.h>
#include <string.h>
#include <stdio.h>

char* abbreviateProduct(int left, int right) {
    const unsigned long long BASE = 1000000000ULL;
    int cap = 8;
    unsigned long long* d = malloc(cap * sizeof(unsigned long long));
    int n = 1;
    d[0] = 1;
    for (int i = left; i <= right; i++) {
        unsigned long long carry = 0;
        for (int j = 0; j < n; j++) {
            unsigned long long cur = d[j] * (unsigned long long)i + carry;
            d[j] = cur % BASE;
            carry = cur / BASE;
        }
        while (carry) {
            if (n >= cap) {
                cap *= 2;
                d = realloc(d, cap * sizeof(unsigned long long));
            }
            d[n++] = carry % BASE;
            carry /= BASE;
        }
    }
    int buflen = n * 9 + 1;
    char* s = malloc(buflen);
    int pos = 0;
    pos += sprintf(s + pos, "%llu", d[n - 1]);
    for (int j = n - 2; j >= 0; j--) {
        pos += sprintf(s + pos, "%09llu", d[j]);
    }
    s[pos] = '\0';
    int slen = pos;
    int c = 0;
    while (slen > 0 && s[slen - 1] == '0') {
        slen--;
        c++;
    }
    s[slen] = '\0';
    char* res = malloc(slen + 32);
    if (slen <= 10) {
        sprintf(res, "%se%d", s, c);
    } else {
        char first5[6], last5[6];
        memcpy(first5, s, 5);
        first5[5] = '\0';
        memcpy(last5, s + slen - 5, 5);
        last5[5] = '\0';
        sprintf(res, "%s...%se%d", first5, last5, c);
    }
    free(d);
    free(s);
    return res;
}
