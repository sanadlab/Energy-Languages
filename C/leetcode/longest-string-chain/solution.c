#include <stdlib.h>
#include <string.h>

// open-addressing hash map: string key -> int (chain length)
typedef struct {
    const char* key;
    int val;
    char used;
} Entry;

static Entry* g_tab;
static int g_cap;

static unsigned long djb2(const char* s, int len) {
    unsigned long h = 5381;
    for (int i = 0; i < len; i++) h = ((h << 5) + h) + (unsigned char)s[i];
    return h;
}

// look up a key given as content buffer (s,len); returns val or 0 if absent
static int map_get(const char* s, int len) {
    unsigned long h = djb2(s, len);
    int mask = g_cap - 1;
    int i = (int)(h & mask);
    while (g_tab[i].used) {
        if ((int)strlen(g_tab[i].key) == len && memcmp(g_tab[i].key, s, len) == 0)
            return g_tab[i].val;
        i = (i + 1) & mask;
    }
    return 0;
}

static void map_put(const char* key, int val) {
    int len = (int)strlen(key);
    unsigned long h = djb2(key, len);
    int mask = g_cap - 1;
    int i = (int)(h & mask);
    while (g_tab[i].used) {
        if ((int)strlen(g_tab[i].key) == len && memcmp(g_tab[i].key, key, len) == 0) {
            g_tab[i].val = val;
            return;
        }
        i = (i + 1) & mask;
    }
    g_tab[i].used = 1;
    g_tab[i].key = key;
    g_tab[i].val = val;
}

static int cmp_len(const void* a, const void* b) {
    const char* x = *(const char* const*)a;
    const char* y = *(const char* const*)b;
    return (int)strlen(x) - (int)strlen(y);
}

int longestStrChain(char** words, int wordsSize) {
    // sort by length ascending
    qsort(words, wordsSize, sizeof(char*), cmp_len);

    g_cap = 1;
    while (g_cap < wordsSize * 2 + 1) g_cap <<= 1;
    g_tab = (Entry*)calloc(g_cap, sizeof(Entry));

    char buf[256];
    int best = 1;
    for (int wi = 0; wi < wordsSize; wi++) {
        const char* w = words[wi];
        int L = (int)strlen(w);
        int cur = 1;
        for (int i = 0; i < L; i++) {
            // predecessor = w with char i removed
            int p = 0;
            for (int j = 0; j < L; j++) {
                if (j == i) continue;
                buf[p++] = w[j];
            }
            buf[p] = '\0';
            int d = map_get(buf, p);
            if (d > 0 && d + 1 > cur) cur = d + 1;
        }
        map_put(w, cur);
        if (cur > best) best = cur;
    }
    free(g_tab);
    return best;
}
