#include <string.h>

static int vowel_index(char ch) {
    switch (ch) {
        case 'a': return 0;
        case 'e': return 1;
        case 'i': return 2;
        case 'o': return 3;
        case 'u': return 4;
        default:  return -1;
    }
}

int countVowelSubstrings(char* word) {
    int n = (int)strlen(word);
    int count = 0;
    for (int i = 0; i < n; i++) {
        if (vowel_index(word[i]) < 0) continue;
        int seen[5] = {0};
        int distinct = 0;
        int j = i;
        while (j < n) {
            int vi = vowel_index(word[j]);
            if (vi < 0) break;
            if (!seen[vi]) {
                seen[vi] = 1;
                distinct++;
            }
            if (distinct == 5) count++;
            j++;
        }
    }
    return count;
}
