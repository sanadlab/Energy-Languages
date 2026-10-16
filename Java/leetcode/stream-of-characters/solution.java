import java.util.*;
import java.util.stream.*;
import java.math.*;

class StreamChecker {
    // A trie of the reversed words, walked backwards from the newest letter.
    private static final class Node {
        final Node[] next = new Node[26];
        boolean end;
    }

    private final Node root = new Node();
    private final StringBuilder stream = new StringBuilder();
    private int maxLen = 0;

    public StreamChecker(String[] words) {
        for (String w : words) {
            Node cur = root;
            for (int i = w.length() - 1; i >= 0; i--) {
                int c = w.charAt(i) - 'a';
                if (cur.next[c] == null) cur.next[c] = new Node();
                cur = cur.next[c];
            }
            cur.end = true;
            maxLen = Math.max(maxLen, w.length());
        }
    }

    public boolean query(char letter) {
        stream.append(letter);
        Node cur = root;
        for (int i = stream.length() - 1, d = 0; i >= 0 && d < maxLen; i--, d++) {
            cur = cur.next[stream.charAt(i) - 'a'];
            if (cur == null) return false;
            if (cur.end) return true;
        }
        return false;
    }
}
