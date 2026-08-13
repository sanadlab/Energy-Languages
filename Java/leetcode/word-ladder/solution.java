import java.util.*;
class Solution {
    public int ladderLength(String beginWord, String endWord, String[] wordList) {
        Set<String> dict = new HashSet<>(Arrays.asList(wordList));
        if (!dict.contains(endWord)) return 0;
        Set<String> visited = new HashSet<>();
        Deque<String> queue = new ArrayDeque<>();
        queue.add(beginWord);
        visited.add(beginWord);
        int level = 1;
        while (!queue.isEmpty()) {
            int sz = queue.size();
            for (int q = 0; q < sz; q++) {
                String word = queue.poll();
                if (word.equals(endWord)) return level;
                char[] arr = word.toCharArray();
                for (int i = 0; i < arr.length; i++) {
                    char old = arr[i];
                    for (char c = 'a'; c <= 'z'; c++) {
                        if (c == old) continue;
                        arr[i] = c;
                        String cand = new String(arr);
                        if (dict.contains(cand) && !visited.contains(cand)) {
                            visited.add(cand);
                            queue.add(cand);
                        }
                    }
                    arr[i] = old;
                }
            }
            level++;
        }
        return 0;
    }
}
