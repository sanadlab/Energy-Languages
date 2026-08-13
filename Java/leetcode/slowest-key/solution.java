class Solution {
    public char slowestKey(int[] releaseTimes, String keysPressed) {
        int n = releaseTimes.length;
        char best = keysPressed.charAt(0);
        int bestDur = releaseTimes[0];
        for (int i = 1; i < n; i++) {
            int dur = releaseTimes[i] - releaseTimes[i - 1];
            if (dur > bestDur || (dur == bestDur && keysPressed.charAt(i) > best)) {
                bestDur = dur;
                best = keysPressed.charAt(i);
            }
        }
        return best;
    }
}
