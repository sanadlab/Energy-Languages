class Solution {
public:
    bool closeStrings(string word1, string word2) {
        if (word1.length() != word2.length()) {
            return false;
        }
        set<char> s1(word1.begin(), word1.end());
        set<char> s2(word2.begin(), word2.end());
        if (s1 != s2) {
            return false;
        }
        vector<int> freq1(26, 0);
        vector<int> freq2(26, 0);
        for (char c : word1) {
            freq1[c - 'a']++;
        }
        for (char c : word2) {
            freq2[c - 'a']++;
        }
        vector<int> v1, v2;
        for (int i = 0; i < 26; i++) {
            if (freq1[i] > 0) {
                v1.push_back(freq1[i]);
            }
            if (freq2[i] > 0) {
                v2.push_back(freq2[i]);
            }
        }
        sort(v1.begin(), v1.end());
        sort(v2.begin(), v2.end());
        return v1 == v2;
    }
};