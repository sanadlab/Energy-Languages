#include <string.h>

int canBeTypedWords(char* text, char* brokenLetters) {
    int broken[26] = {0};
    for (int i = 0; brokenLetters[i]; i++) {
        broken[brokenLetters[i] - 'a'] = 1;
    }
    int count = 0;
    int len = (int)strlen(text);
    int i = 0;
    while (i < len) {
        while (i < len && text[i] == ' ') i++;
        if (i >= len) break;
        int bad = 0;
        while (i < len && text[i] != ' ') {
            char c = text[i];
            if (c >= 'a' && c <= 'z' && broken[c - 'a']) bad = 1;
            i++;
        }
        if (!bad) count++;
    }
    return count;
}
