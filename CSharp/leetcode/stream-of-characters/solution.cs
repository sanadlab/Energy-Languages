public class StreamChecker {
    private class Node {
        public Node[] Next = new Node[26];
        public bool Word = false;
    }
    private Node root;
    private List<char> stream;
    private int maxLen;

    public StreamChecker(string[] words) {
        root = new Node();
        stream = new List<char>();
        maxLen = 0;
        foreach (var w in words) {
            Node node = root;
            for (int i = w.Length - 1; i >= 0; i--) {
                int c = w[i] - 'a';
                if (node.Next[c] == null) node.Next[c] = new Node();
                node = node.Next[c];
            }
            node.Word = true;
            if (w.Length > maxLen) maxLen = w.Length;
        }
    }

    public bool Query(char letter) {
        stream.Add(letter);
        Node node = root;
        int n = stream.Count;
        for (int step = 0; step < maxLen && step < n; step++) {
            int c = stream[n - 1 - step] - 'a';
            if (node.Next[c] == null) return false;
            node = node.Next[c];
            if (node.Word) return true;
        }
        return false;
    }
}
