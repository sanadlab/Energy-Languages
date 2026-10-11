#include <string>
#include <vector>
#include <unordered_set>
using namespace std;

class Solution {
public:
    int ladderLength(string beginWord, string endWord, vector<string>& wordList) {
        unordered_set<string> remaining(wordList.begin(), wordList.end());
        if (!remaining.count(endWord)) return 0;

        unordered_set<string> front{beginWord};
        unordered_set<string> back{endWord};
        remaining.erase(beginWord);
        remaining.erase(endWord);

        int length = 1;

        while (!front.empty() && !back.empty()) {
            if (front.size() > back.size()) {
                front.swap(back);
            }

            unordered_set<string> next;

            for (const string& current : front) {
                string word = current;

                for (int i = 0; i < static_cast<int>(word.size()); ++i) {
                    char original = word[i];

                    for (char c = 'a'; c <= 'z'; ++c) {
                        if (c == original) continue;
                        word[i] = c;

                        if (back.count(word)) return length + 1;

                        auto it = remaining.find(word);
                        if (it != remaining.end()) {
                            next.insert(word);
                            remaining.erase(it);
                        }
                    }

                    word[i] = original;
                }
            }

            front.swap(next);
            ++length;
        }

        return 0;
    }
};