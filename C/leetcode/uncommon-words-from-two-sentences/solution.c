#include <stdlib.h>
#include <string.h>

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
char** uncommonFromSentences(char* s1, char* s2, int* returnSize) {
    int l1 = (int) strlen(s1), l2 = (int) strlen(s2);
    char* buf = (char*) malloc(l1 + l2 + 2);
    memcpy(buf, s1, l1);
    buf[l1] = ' ';
    memcpy(buf + l1 + 1, s2, l2);
    buf[l1 + 1 + l2] = '\0';

    char** words = (char**) malloc(sizeof(char*) * (l1 + l2 + 2));
    int wc = 0;
    char* p = buf;
    while (*p) {
        while (*p == ' ') p++;
        if (!*p) break;
        char* start = p;
        while (*p && *p != ' ') p++;
        if (*p) { *p = '\0'; p++; }
        words[wc++] = start;
    }

    char** res = (char**) malloc(sizeof(char*) * (wc > 0 ? wc : 1));
    int rc = 0;
    for (int i = 0; i < wc; i++) {
        int c = 0;
        for (int j = 0; j < wc; j++)
            if (strcmp(words[i], words[j]) == 0) c++;
        if (c == 1) {
            res[rc] = (char*) malloc(strlen(words[i]) + 1);
            strcpy(res[rc], words[i]);
            rc++;
        }
    }
    free(words);
    free(buf);
    *returnSize = rc;
    return res;
}
