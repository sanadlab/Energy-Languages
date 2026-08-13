public class Solution {
    public int CountVowelSubstrings(string word) {
        string vowels = "aeiou";
        List<string> runs = new List<string>();
        string current = "";
        
        foreach (char c in word) {
            if (vowels.Contains(c)) {
                current += c;
            } else {
                if (current != "") {
                    runs.Add(current);
                    current = "";
                }
            }
        }
        if (current != "") {
            runs.Add(current);
        }
        
        int count = 0;
        
        foreach (string run in runs) {
            int len = run.Length;
            for (int start = 0; start < len; start++) {
                for (int end = start; end < len; end++) {
                    string substr = run.Substring(start, end - start + 1);
                    if (new HashSet<char>(substr).Count == 5) {
                        count++;
                    }
                }
            }
        }
        
        return count;
    }
}