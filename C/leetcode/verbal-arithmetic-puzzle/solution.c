#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

static char** vap_words;
static int* vap_wlen;
static int vap_wordsSize;
static char* vap_result;
static int vap_maxlen;
static int vap_aval[26];
static bool vap_ahas[26];
static bool vap_used[10];
static bool vap_lead[26];

static bool vap_solve(int col, int row, int carry) {
    if (col == vap_maxlen) return carry == 0;
    if (row < vap_wordsSize) {
        int wl = vap_wlen[row];
        if (col >= wl) return vap_solve(col, row + 1, carry);
        int ch = vap_words[row][wl - 1 - col] - 'A';
        if (vap_ahas[ch]) return vap_solve(col, row + 1, carry);
        for (int d = 0; d < 10; d++) {
            if (!vap_used[d] && !(d == 0 && vap_lead[ch])) {
                vap_used[d] = true; vap_ahas[ch] = true; vap_aval[ch] = d;
                if (vap_solve(col, row + 1, carry)) return true;
                vap_used[d] = false; vap_ahas[ch] = false;
            }
        }
        return false;
    }
    int s = carry;
    for (int i = 0; i < vap_wordsSize; i++) {
        int wl = vap_wlen[i];
        if (col < wl) s += vap_aval[vap_words[i][wl - 1 - col] - 'A'];
    }
    int digit = s % 10;
    int new_carry = s / 10;
    int rch = vap_result[vap_maxlen - 1 - col] - 'A';
    if (vap_ahas[rch]) {
        if (vap_aval[rch] == digit) return vap_solve(col + 1, 0, new_carry);
        return false;
    }
    if (vap_used[digit]) return false;
    if (digit == 0 && vap_lead[rch]) return false;
    vap_used[digit] = true; vap_ahas[rch] = true; vap_aval[rch] = digit;
    if (vap_solve(col + 1, 0, new_carry)) return true;
    vap_used[digit] = false; vap_ahas[rch] = false;
    return false;
}

bool isSolvable(char** words, int wordsSize, char* result) {
    vap_maxlen = (int)strlen(result);
    vap_words = words; vap_wordsSize = wordsSize; vap_result = result;
    vap_wlen = malloc((size_t)wordsSize * sizeof(int));
    for (int i = 0; i < wordsSize; i++) {
        vap_wlen[i] = (int)strlen(words[i]);
        if (vap_wlen[i] > vap_maxlen) { free(vap_wlen); return false; }
    }
    for (int i = 0; i < 26; i++) { vap_ahas[i] = false; vap_lead[i] = false; vap_aval[i] = 0; }
    for (int i = 0; i < 10; i++) vap_used[i] = false;
    for (int i = 0; i < wordsSize; i++) {
        if (vap_wlen[i] > 1) vap_lead[words[i][0] - 'A'] = true;
    }
    if (vap_maxlen > 1) vap_lead[result[0] - 'A'] = true;

    bool ans = vap_solve(0, 0, 0);
    free(vap_wlen);
    return ans;
}
