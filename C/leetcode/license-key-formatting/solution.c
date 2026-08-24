char* licenseKeyFormatting(char* s, int k) {
    int n = strlen(s);
    char* buf = malloc(n + 1); int m = 0;
    for (int i = 0; i < n; i++) if (s[i] != '-') buf[m++] = toupper((unsigned char)s[i]);
    char* res = malloc(2 * m + 2); int p = 0, idx = 0;
    int first = m % k; if (first == 0) first = k;
    for (int i = 0; i < first && idx < m; i++) res[p++] = buf[idx++];
    while (idx < m) { res[p++] = '-'; for (int i = 0; i < k; i++) res[p++] = buf[idx++]; }
    res[p] = 0; free(buf);
    return res;
}
