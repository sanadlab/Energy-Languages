#include <stdlib.h>
#include <string.h>
int* diStringMatch(char* s, int* returnSize) {
    int n = strlen(s);
    int* res = malloc((n + 1) * sizeof(int));   // un-cast malloc: fails as C++, ok as C
    int lo = 0, hi = n;
    for (int i = 0; i < n; i++) res[i] = (s[i] == 'I') ? lo++ : hi--;
    res[n] = lo;
    *returnSize = n + 1;
    return res;
}
