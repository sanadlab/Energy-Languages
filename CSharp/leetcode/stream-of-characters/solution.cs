public class StreamChecker
{
    private sealed class TrieNode
    {
        public readonly TrieNode[] Children = new TrieNode[26];
        public bool IsWord;
    }

    private readonly TrieNode root = new TrieNode();
    private readonly char[] history;
    private int nextWrite;
    private int count;

    public StreamChecker(string[] words)
    {
        int maxLength = 0;

        foreach (string word in words)
        {
            if (word.Length > maxLength)
                maxLength = word.Length;

            TrieNode node = root;

            for (int i = word.Length - 1; i >= 0; i--)
            {
                int index = word[i] - 'a';

                if (node.Children[index] == null)
                    node.Children[index] = new TrieNode();

                node = node.Children[index];
            }

            node.IsWord = true;
        }

        history = new char[maxLength];
    }

    public bool Query(char letter)
    {
        history[nextWrite] = letter;
        nextWrite = (nextWrite + 1) % history.Length;

        if (count < history.Length)
            count++;

        TrieNode node = root;
        int position = nextWrite;

        for (int i = 0; i < count; i++)
        {
            position--;
            if (position < 0)
                position = history.Length - 1;

            node = node.Children[history[position] - 'a'];

            if (node == null)
                return false;

            if (node.IsWord)
                return true;
        }

        return false;
    }
}