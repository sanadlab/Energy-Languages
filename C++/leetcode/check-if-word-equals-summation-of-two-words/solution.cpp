class Solution {
public:
    bool isSumEqual(string firstWord, string secondWord, string targetWord) {
        return val(firstWord) + val(secondWord) == val(targetWord);
    }
private:
    long val(const string& s) {
        long n = 0;
        for (char c : s) n = n * 10 + (c - 'a');
        return n;
    }
};
