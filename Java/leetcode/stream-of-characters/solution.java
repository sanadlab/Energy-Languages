class StreamChecker {
    private static class Node {
        Node[] next = new Node[26];
        boolean word = false;
    }
    private Node root;
    private StringBuilder stream;
    private int maxLen;

    public StreamChecker(String[] words) {
        root = new Node();
        stream = new StringBuilder();
        maxLen = 0;
        for (String w : words) {
            Node node = root;
            for (int i = w.length() - 1; i >= 0; i--) {
                int c = w.charAt(i) - 'a';
                if (node.next[c] == null) node.next[c] = new Node();
                node = node.next[c];
            }
            node.word = true;
            if (w.length() > maxLen) maxLen = w.length();
        }
    }

    public boolean query(char letter) {
        stream.append(letter);
        Node node = root;
        int n = stream.length();
        for (int step = 0; step < maxLen && step < n; step++) {
            int c = stream.charAt(n - 1 - step) - 'a';
            if (node.next[c] == null) return false;
            node = node.next[c];
            if (node.word) return true;
        }
        return false;
    }
}
