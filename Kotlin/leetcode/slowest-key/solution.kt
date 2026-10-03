class Solution {
    fun slowestKey(releaseTimes: IntArray, keysPressed: String): Char {
        var best = keysPressed[0]
        var bestDur = releaseTimes[0]
        for (i in 1 until releaseTimes.size) {
            val dur = releaseTimes[i] - releaseTimes[i - 1]
            if (dur > bestDur || (dur == bestDur && keysPressed[i] > best)) {
                bestDur = dur
                best = keysPressed[i]
            }
        }
        return best
    }
}
