/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
static int fsmall(const char* s) {
    char mn = 127;
    for (const char* p = s; *p; p++) if (*p < mn) mn = *p;
    int c = 0;
    for (const char* p = s; *p; p++) if (*p == mn) c++;
    return c;
}

int* numSmallerByFrequency(char** queries, int queriesSize, char** words, int wordsSize, int* returnSize) {
    int* wf = (int*) malloc(sizeof(int) * (wordsSize > 0 ? wordsSize : 1));
    for (int i = 0; i < wordsSize; i++) wf[i] = fsmall(words[i]);
    int* res = (int*) malloc(sizeof(int) * (queriesSize > 0 ? queriesSize : 1));
    for (int i = 0; i < queriesSize; i++) {
        int q = fsmall(queries[i]);
        int cnt = 0;
        for (int j = 0; j < wordsSize; j++) if (wf[j] > q) cnt++;
        res[i] = cnt;
    }
    free(wf);
    *returnSize = queriesSize;
    return res;
}
