#include <stdbool.h>

bool areOccurrencesEqual(char* s) {
    int counts[26] = {0};
    for (int i = 0; s[i] != '\0'; i++) {
        counts[s[i] - 'a']++;
    }
    int ref = 0;
    for (int i = 0; i < 26; i++) {
        if (counts[i] != 0) {
            if (ref == 0) {
                ref = counts[i];
            } else if (counts[i] != ref) {
                return false;
            }
        }
    }
    return true;
}
