public class Solution {
    public int MinSwaps(string s) {
        int open = 0;
        foreach (char c in s) {
            if (c == '[') open++;
            else if (open > 0) open--;
        }
        return (open + 1) / 2;
    }
}
