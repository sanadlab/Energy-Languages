class Solution {
public:
    string evaluate(string s, vector<vector<string>>& knowledge) {
        unordered_map<string, string> knowledge_map;
        for (auto &kv : knowledge) {
            knowledge_map[kv[0]] = kv[1];
        }
        string result = "";
        int i = 0;
        while (i < s.length()) {
            if (s[i] == '(') {
                int j = i + 1;
                int k = j;
                while (k < s.length() && s[k] != ')') {
                    k++;
                }
                string key = s.substr(j, k - j);
                if (knowledge_map.find(key) != knowledge_map.end()) {
                    result += knowledge_map[key];
                } else {
                    result += "?";
                }
                i = k + 1;
            } else {
                result += s[i];
                i++;
            }
        }
        return result;
    }
};