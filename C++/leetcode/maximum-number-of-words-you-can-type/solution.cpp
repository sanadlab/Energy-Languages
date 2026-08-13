class Solution {
public:
    int canBeTypedWords(string text, string brokenLetters) {
        bool broken[26] = {false};
        for (char c : brokenLetters)
            if (c >= 'a' && c <= 'z') broken[c - 'a'] = true;
        int count = 0;
        bool ok = true;
        for (size_t i = 0; i <= text.size(); ++i) {
            if (i == text.size() || text[i] == ' ') {
                if (ok) ++count;
                ok = true;
            } else {
                char c = text[i];
                if (c >= 'a' && c <= 'z' && broken[c - 'a']) ok = false;
            }
        }
        return count;
    }
};
