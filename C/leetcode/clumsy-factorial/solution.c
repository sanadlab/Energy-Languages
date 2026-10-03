#include <stdlib.h>

int clumsy(int n) {
    long long* stack = malloc((n + 1) * sizeof(long long));
    int sp = 0;
    stack[sp++] = n;
    int op = 0;
    for (int x = n - 1; x > 0; x--) {
        if (op == 0) {
            long long top = stack[--sp];
            stack[sp++] = top * x;
        } else if (op == 1) {
            long long top = stack[--sp];
            stack[sp++] = (long long)((double)top / (double)x);
        } else if (op == 2) {
            stack[sp++] = x;
        } else {
            stack[sp++] = -x;
        }
        op = (op + 1) % 4;
    }
    long long sum = 0;
    for (int i = 0; i < sp; i++) sum += stack[i];
    free(stack);
    return (int)sum;
}
