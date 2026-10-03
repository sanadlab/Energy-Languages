#include <string.h>

int minOperations(char* s) {
    int n = (int)strlen(s);
    int cnt = 0;
    for (int i = 0; i < n; i++) {
        char expected = (i % 2 == 0) ? '0' : '1';
        if (s[i] != expected) cnt++;
    }
    return cnt < (n - cnt) ? cnt : (n - cnt);
}
