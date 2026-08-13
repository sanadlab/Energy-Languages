using System;
using System.Collections.Generic;

public class Solution {
    public int LadderLength(string beginWord, string endWord, IList<string> wordList) {
        var wordSet = new HashSet<string>(wordList);
        if (!wordSet.Contains(endWord)) return 0;

        var queue = new Queue<(string word, int length)>();
        queue.Enqueue((beginWord, 1));
        var visited = new HashSet<string> { beginWord };

        while (queue.Count > 0) {
            var (currentWord, length) = queue.Dequeue();

            if (currentWord == endWord) return length;

            char[] chars = currentWord.ToCharArray();
            for (int i = 0; i < chars.Length; i++) {
                char originalChar = chars[i];
                for (char c = 'a'; c <= 'z'; c++) {
                    if (c == originalChar) continue;
                    chars[i] = c;
                    string nextWord = new string(chars);
                    if (wordSet.Contains(nextWord) && !visited.Contains(nextWord)) {
                        visited.Add(nextWord);
                        queue.Enqueue((nextWord, length + 1));
                    }
                }
                chars[i] = originalChar;
            }
        }

        return 0;
    }
}