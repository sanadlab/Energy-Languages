/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
/* Build the formatted numbers for digit-substring d[0..len) (mirrors Python
 * make()), storing malloc'd strings into out[]; returns how many produced. */
static int make(const char* d, int len, char** out) {
    int cnt = 0;
    if (len == 1) {
        char* s = (char*) malloc(2);
        s[0] = d[0]; s[1] = 0;
        out[cnt++] = s;
        return cnt;
    }
    if (d[0] != '0') {
        char* s = (char*) malloc(len + 1);
        memcpy(s, d, len); s[len] = 0;
        out[cnt++] = s;
    }
    for (int i = 1; i < len; i++) {
        /* l = d[0..i), r = d[i..len); keep if (l=="0" || l[0]!='0') && r.back()!='0' */
        bool lok = (i == 1 && d[0] == '0') || (d[0] != '0');
        bool rok = d[len - 1] != '0';
        if (lok && rok) {
            char* s = (char*) malloc(len + 2);
            memcpy(s, d, i); s[i] = '.'; memcpy(s + i + 1, d + i, len - i); s[len + 1] = 0;
            out[cnt++] = s;
        }
    }
    return cnt;
}

char** ambiguousCoordinates(char* s, int* returnSize) {
    int slen = (int) strlen(s);
    int n = slen - 2;                 /* digits = s[1:-1] */
    const char* digits = s + 1;
    int cap = n * n * n + 1;
    char** res = (char**) malloc(sizeof(char*) * cap);
    int cnt = 0;
    char* bufA[16]; char* bufB[16];
    for (int i = 1; i < n; i++) {
        int la = make(digits, i, bufA);
        int lb = make(digits + i, n - i, bufB);
        for (int x = 0; x < la; x++)
            for (int y = 0; y < lb; y++) {
                char* str = (char*) malloc(strlen(bufA[x]) + strlen(bufB[y]) + 6);
                sprintf(str, "(%s, %s)", bufA[x], bufB[y]);
                res[cnt++] = str;
            }
        for (int x = 0; x < la; x++) free(bufA[x]);
        for (int y = 0; y < lb; y++) free(bufB[y]);
    }
    *returnSize = cnt;
    return res;
}
