#include <string>
#include <vector>
#include <unordered_set>
#include <queue>

using namespace std;

class Solution {
public:
    int ladderLength(string beginWord, string endWord, vector<string>& wordList) {
        unordered_set<string> wordSet(wordList.begin(), wordList.end());
        if (wordSet.find(endWord) == wordSet.end()) return 0;

        queue<pair<string,int>> q;
        q.push({beginWord, 1});
        unordered_set<string> visited;
        visited.insert(beginWord);

        while (!q.empty()) {
            auto [word, length] = q.front();
            q.pop();

            if (word == endWord) return length;

            for (int i = 0; i < (int)word.size(); i++) {
                char original_char = word[i];
                for (char c = 'a'; c <= 'z'; c++) {
                    if (c == original_char) continue;
                    word[i] = c;
                    if (wordSet.count(word) && !visited.count(word)) {
                        visited.insert(word);
                        q.push({word, length + 1});
                    }
                }
                word[i] = original_char;
            }
        }

        return 0;
    }
};