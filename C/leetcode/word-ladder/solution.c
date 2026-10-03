#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

static unsigned long wl_hash(const char* s) {
    unsigned long h = 1469598103934665603UL;
    while (*s) { h ^= (unsigned char)(*s++); h *= 1099511628211UL; }
    return h;
}

int ladderLength(char* beginWord, char* endWord, char** wordList, int wordListSize) {
    bool endPresent = false;
    for (int i = 0; i < wordListSize; i++) {
        if (strcmp(wordList[i], endWord) == 0) { endPresent = true; break; }
    }
    if (!endPresent) return 0;

    int L = (int)strlen(beginWord);

    /* open-addressing hash set: word -> canonical index in wordList */
    int cap = 8;
    while (cap < wordListSize * 2) cap <<= 1;
    unsigned int mask = (unsigned int)(cap - 1);
    int* table = malloc((size_t)cap * sizeof(int));
    for (int i = 0; i < cap; i++) table[i] = -1;
    for (int i = 0; i < wordListSize; i++) {
        unsigned int h = (unsigned int)(wl_hash(wordList[i]) & mask);
        while (table[h] != -1) {
            if (strcmp(wordList[table[h]], wordList[i]) == 0) break;
            h = (h + 1) & mask;
        }
        if (table[h] == -1) table[h] = i;
    }

    bool* visited = calloc((size_t)wordListSize, sizeof(bool));

    /* mark beginWord visited if it is in the set (Python seeds visited={beginWord}) */
    {
        unsigned int h = (unsigned int)(wl_hash(beginWord) & mask);
        while (table[h] != -1) {
            if (strcmp(wordList[table[h]], beginWord) == 0) { visited[table[h]] = true; break; }
            h = (h + 1) & mask;
        }
    }

    char** qword = malloc((size_t)(wordListSize + 1) * sizeof(char*));
    int* qlevel = malloc((size_t)(wordListSize + 1) * sizeof(int));
    int head = 0, tail = 0;
    qword[tail] = beginWord; qlevel[tail] = 1; tail++;

    char* buf = malloc((size_t)(L + 1));
    int answer = 0;

    while (head < tail && answer == 0) {
        char* cur = qword[head];
        int level = qlevel[head];
        head++;
        memcpy(buf, cur, (size_t)(L + 1));
        for (int i = 0; i < L && answer == 0; i++) {
            char orig = buf[i];
            for (char c = 'a'; c <= 'z'; c++) {
                buf[i] = c;
                if (strcmp(buf, endWord) == 0) { answer = level + 1; break; }
                unsigned int h = (unsigned int)(wl_hash(buf) & mask);
                int idx = -1;
                while (table[h] != -1) {
                    if (strcmp(wordList[table[h]], buf) == 0) { idx = table[h]; break; }
                    h = (h + 1) & mask;
                }
                if (idx != -1 && !visited[idx]) {
                    visited[idx] = true;
                    qword[tail] = wordList[idx];
                    qlevel[tail] = level + 1;
                    tail++;
                }
            }
            buf[i] = orig;
        }
    }

    free(table); free(visited); free(qword); free(qlevel); free(buf);
    return answer;
}
