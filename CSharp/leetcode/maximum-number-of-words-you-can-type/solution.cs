public class Solution {
    public int CanBeTypedWords(string text, string brokenLetters) {
        var broken = new HashSet<char>(brokenLetters);
        int count = 0;
        foreach (var word in text.Split(' ')) {
            bool ok = true;
            foreach (var c in word) {
                if (broken.Contains(c)) { ok = false; break; }
            }
            if (ok) count++;
        }
        return count;
    }
}
