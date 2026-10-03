#include <math.h>

int countTriples(int n) {
    int count = 0;
    for (int a = 1; a <= n; a++) {
        for (int b = a; b <= n; b++) {
            int c_square = a * a + b * b;
            int c = (int)sqrt((double)c_square);
            if (c <= n && c * c == c_square) {
                count += 2;
            }
        }
    }
    return count;
}
