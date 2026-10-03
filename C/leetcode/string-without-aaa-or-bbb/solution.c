#include <stdlib.h>
#include <stdbool.h>

char* strWithout3a3b(int a, int b) {
    char* res = malloc((size_t)(a + b + 1));
    int len = 0;
    while (a > 0 || b > 0) {
        bool write_a;
        if (len >= 2 && res[len - 1] == res[len - 2]) {
            write_a = (res[len - 1] == 'b');
        } else {
            write_a = (a >= b);
        }
        if (write_a) {
            if (a == 0) break;
            res[len++] = 'a';
            a--;
        } else {
            if (b == 0) break;
            res[len++] = 'b';
            b--;
        }
    }
    res[len] = '\0';
    return res;
}
