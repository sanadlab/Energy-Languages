public class Solution {
    public bool JudgeCircle(string moves) {
        int x = 0, y = 0;
        foreach (char c in moves) {
            switch (c) {
                case 'U': y++; break;
                case 'D': y--; break;
                case 'R': x++; break;
                case 'L': x--; break;
            }
        }
        return x == 0 && y == 0;
    }
}
