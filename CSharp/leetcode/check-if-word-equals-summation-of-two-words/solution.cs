public class Solution {
    public bool IsSumEqual(string firstWord, string secondWord, string targetWord) {
        return Val(firstWord) + Val(secondWord) == Val(targetWord);
    }
    private long Val(string s) {
        long n = 0;
        foreach (char c in s) n = n * 10 + (c - 'a');
        return n;
    }
}
