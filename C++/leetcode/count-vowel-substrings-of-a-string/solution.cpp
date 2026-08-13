class Solution {
public:
    int countVowelSubstrings(string word) {
        string vowels = "aeiou";
        vector<string> segments;
        string current = "";
        for (char c : word) {
            if (vowels.find(c) != string::npos) {
                current += c;
            } else {
                if (!current.empty()) {
                    segments.push_back(current);
                    current = "";
                }
            }
        }
        if (!current.empty()) {
            segments.push_back(current);
        }

        int total = 0;
        for (string seg : segments) {
            int len = seg.length();
            if (len < 5) continue;
            for (int i = 0; i < len; i++) {
                unordered_map<char, int> count;
                int j = i;
                while (j < len) {
                    count[seg[j]]++;
                    if (count['a'] > 0 && count['e'] > 0 && count['i'] > 0 && count['o'] > 0 && count['u'] > 0) {
                        total += (len - j);
                        break;
                    }
                    j++;
                }
            }
        }
        return total;
    }
};