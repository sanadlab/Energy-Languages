import java.util.*;
import java.util.stream.*;
import java.math.*;

class Solution {
    public int ladderLength(String beginWord, String endWord, List<String> wordList) {
        Set<String> words = new HashSet<>(wordList);
        if (!words.contains(endWord)) return 0;
        Deque<String> queue = new ArrayDeque<>();
        Set<String> seen = new HashSet<>();
        queue.add(beginWord);
        seen.add(beginWord);
        for (int steps = 1; !queue.isEmpty(); steps++) {
            for (int size = queue.size(); size > 0; size--) {
                String w = queue.poll();
                if (w.equals(endWord)) return steps;
                char[] cs = w.toCharArray();
                for (int i = 0; i < cs.length; i++) {
                    char orig = cs[i];
                    for (char c = 'a'; c <= 'z'; c++) {
                        if (c == orig) continue;
                        cs[i] = c;
                        String next = new String(cs);
                        if (words.contains(next) && seen.add(next)) queue.add(next);
                    }
                    cs[i] = orig;
                }
            }
        }
        return 0;
    }
}
