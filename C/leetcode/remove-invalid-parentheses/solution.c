static bool valid(const char* s) {
    int c = 0;
    for (int i = 0; s[i]; i++) { if (s[i] == '(') c++; else if (s[i] == ')') { if (--c < 0) return false; } }
    return c == 0;
}
char** removeInvalidParentheses(char* s, int* returnSize) {
    char** cur = malloc(sizeof(char*)); cur[0] = strdup(s); int curN = 1;
    while (1) {
        char** res = malloc(sizeof(char*) * (curN + 1)); int rN = 0;
        for (int i = 0; i < curN; i++) if (valid(cur[i])) {
            int dup = 0; for (int j = 0; j < rN; j++) if (!strcmp(res[j], cur[i])) { dup = 1; break; }
            if (!dup) res[rN++] = strdup(cur[i]);
        }
        if (rN > 0) { *returnSize = rN; return res; }
        free(res);
        int cap = 16, nN = 0; char** nxt = malloc(sizeof(char*) * cap);
        for (int i = 0; i < curN; i++) {
            char* t = cur[i]; int L = strlen(t);
            for (int k = 0; k < L; k++) {
                if (t[k] != '(' && t[k] != ')') continue;
                char* nw = malloc(L + 1); int p = 0;
                for (int x = 0; x < L; x++) if (x != k) nw[p++] = t[x]; nw[p] = 0;
                int dup = 0; for (int j = 0; j < nN; j++) if (!strcmp(nxt[j], nw)) { dup = 1; break; }
                if (dup) { free(nw); continue; }
                if (nN == cap) { cap *= 2; nxt = realloc(nxt, sizeof(char*) * cap); }
                nxt[nN++] = nw;
            }
        }
        for (int i = 0; i < curN; i++) free(cur[i]); free(cur);
        cur = nxt; curN = nN;
        if (curN == 0) { *returnSize = 1; char** r = malloc(sizeof(char*)); r[0] = strdup(""); return r; }
    }
}
