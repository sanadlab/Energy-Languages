class Solution {
  String slowestKey(List<int> releaseTimes, String keysPressed) {
    String best = keysPressed[0];
    int bestDur = releaseTimes[0];
    for (int i = 1; i < releaseTimes.length; i++) {
      int dur = releaseTimes[i] - releaseTimes[i - 1];
      if (dur > bestDur ||
          (dur == bestDur && keysPressed[i].compareTo(best) > 0)) {
        bestDur = dur;
        best = keysPressed[i];
      }
    }
    return best;
  }
}
