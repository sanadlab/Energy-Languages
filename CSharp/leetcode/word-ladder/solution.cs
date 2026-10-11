using System.Collections.Generic;

public class Solution {
    public int LadderLength(string beginWord, string endWord, IList<string> wordList) {
        var unvisited = new HashSet<string>(wordList);
        if (!unvisited.Contains(endWord)) {
            return 0;
        }

        var front = new HashSet<string> { beginWord };
        var back = new HashSet<string> { endWord };
        unvisited.Remove(beginWord);
        unvisited.Remove(endWord);

        int length = 1;

        while (front.Count > 0 && back.Count > 0) {
            if (front.Count > back.Count) {
                var temp = front;
                front = back;
                back = temp;
            }

            var next = new HashSet<string>();

            foreach (string word in front) {
                char[] chars = word.ToCharArray();

                for (int i = 0; i < chars.Length; i++) {
                    char original = chars[i];

                    for (char c = 'a'; c <= 'z'; c++) {
                        if (c == original) {
                            continue;
                        }

                        chars[i] = c;
                        string candidate = new string(chars);

                        if (back.Contains(candidate)) {
                            return length + 1;
                        }

                        if (unvisited.Remove(candidate)) {
                            next.Add(candidate);
                        }
                    }

                    chars[i] = original;
                }
            }

            front = next;
            length++;
        }

        return 0;
    }
}