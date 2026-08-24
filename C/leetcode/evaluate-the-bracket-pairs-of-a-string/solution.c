char* evaluate(char* s, char*** knowledge, int knowledgeSize, int* knowledgeColSize) {
    int cap = strlen(s) + 16, p = 0;
    char* res = malloc(cap);
    for (int i = 0; s[i]; ) {
        if (s[i] == '(') {
            i++;
            char key[32]; int kl = 0;
            while (s[i] && s[i] != ')') key[kl++] = s[i++];
            key[kl] = 0;
            if (s[i] == ')') i++;
            const char* val = "?";
            for (int k = 0; k < knowledgeSize; k++)
                if (strcmp(knowledge[k][0], key) == 0) { val = knowledge[k][1]; break; }
            int vl = strlen(val);
            while (p + vl + 1 > cap) { cap *= 2; res = realloc(res, cap); }
            memcpy(res + p, val, vl); p += vl;
        } else {
            if (p + 2 > cap) { cap *= 2; res = realloc(res, cap); }
            res[p++] = s[i++];
        }
    }
    res[p] = 0;
    return res;
}
