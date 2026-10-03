#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

static int cmp_int(const void* x, const void* y) {
    int a = *(const int*)x, b = *(const int*)y;
    return (a > b) - (a < b);
}

bool closeStrings(char* word1, char* word2) {
    int l1 = (int)strlen(word1), l2 = (int)strlen(word2);
    if (l1 != l2) return false;

    int f1[26] = {0}, f2[26] = {0};
    for (int i = 0; i < l1; i++) {
        f1[word1[i] - 'a']++;
        f2[word2[i] - 'a']++;
    }
    // same set of characters present
    for (int i = 0; i < 26; i++) {
        if ((f1[i] > 0 && f2[i] == 0) || (f2[i] > 0 && f1[i] == 0)) return false;
    }
    // same frequency multiset
    qsort(f1, 26, sizeof(int), cmp_int);
    qsort(f2, 26, sizeof(int), cmp_int);
    for (int i = 0; i < 26; i++) {
        if (f1[i] != f2[i]) return false;
    }
    return true;
}
