#include <string.h>

int removePalindromeSub(char* s) {
    int n = (int)strlen(s);
    if (n == 0) return 0;
    for (int i = 0, j = n - 1; i < j; i++, j--) {
        if (s[i] != s[j]) return 2;
    }
    return 1;
}
