public class Solution {
    public char SlowestKey(int[] releaseTimes, string keysPressed) {
        int n = releaseTimes.Length;
        char best = keysPressed[0];
        int bestDur = releaseTimes[0];
        for (int i = 1; i < n; i++) {
            int dur = releaseTimes[i] - releaseTimes[i - 1];
            if (dur > bestDur || (dur == bestDur && keysPressed[i] > best)) {
                bestDur = dur;
                best = keysPressed[i];
            }
        }
        return best;
    }
}
