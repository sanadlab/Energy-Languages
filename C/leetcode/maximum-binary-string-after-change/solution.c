#include <stdlib.h>
#include <string.h>

char* maximumBinaryString(char* binary) {
    int n = (int)strlen(binary);
    int first = -1;
    for (int i = 0; i < n; i++) {
        if (binary[i] == '0') { first = i; break; }
    }
    char* res = (char*)malloc((size_t)n + 1);
    if (first == -1) {
        memcpy(res, binary, (size_t)n + 1);
        return res;
    }
    int zeros = 0;
    for (int i = 0; i < n; i++) if (binary[i] == '0') zeros++;
    for (int i = 0; i < n; i++) res[i] = '1';
    res[first + zeros - 1] = '0';
    res[n] = '\0';
    return res;
}
