#include <string>
#include <vector>
#include <unordered_map>
using namespace std;

class Solution {
public:
    string evaluate(string s, vector<vector<string>>& knowledge) {
        unordered_map<string, string> values;
        values.reserve(knowledge.size());
        for (const auto& entry : knowledge) {
            values.emplace(entry[0], entry[1]);
        }

        string result;
        result.reserve(s.size());

        size_t i = 0;
        while (i < s.size()) {
            if (s[i] != '(') {
                result += s[i++];
                continue;
            }

            size_t start = ++i;
            while (s[i] != ')') {
                ++i;
            }

            auto it = values.find(s.substr(start, i - start));
            if (it != values.end()) {
                result += it->second;
            } else {
                result += '?';
            }
            ++i;
        }

        return result;
    }
};