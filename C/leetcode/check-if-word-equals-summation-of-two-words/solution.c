#include <stdbool.h>

static long long word_to_num(char* word) {
    long long num = 0;
    for (int i = 0; word[i] != '\0'; i++) {
        num = num * 10 + (word[i] - 'a');
    }
    return num;
}

bool isSumEqual(char* firstWord, char* secondWord, char* targetWord) {
    return word_to_num(firstWord) + word_to_num(secondWord) == word_to_num(targetWord);
}
