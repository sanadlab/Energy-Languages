static int cmpstr(const void* a, const void* b) { return strcmp(*(char**)a, *(char**)b); }
char*** suggestedProducts(char** products, int productsSize, char* searchWord,
                          int* returnSize, int** returnColumnSizes) {
    char** ps = malloc(sizeof(char*) * productsSize);
    memcpy(ps, products, sizeof(char*) * productsSize);
    qsort(ps, productsSize, sizeof(char*), cmpstr);
    int wl = strlen(searchWord);
    *returnSize = wl;
    char*** res = malloc(sizeof(char**) * wl);
    *returnColumnSizes = malloc(sizeof(int) * wl);
    for (int L = 1; L <= wl; L++) {
        char** row = malloc(sizeof(char*) * 3);
        int cnt = 0;
        for (int i = 0; i < productsSize && cnt < 3; i++)
            if ((int)strlen(ps[i]) >= L && strncmp(ps[i], searchWord, L) == 0)
                row[cnt++] = strdup(ps[i]);
        res[L - 1] = row;
        (*returnColumnSizes)[L - 1] = cnt;
    }
    free(ps);
    return res;
}
