object Solution {
    def slowestKey(releaseTimes: Array[Int], keysPressed: String): Char = {
        var best = keysPressed.charAt(0)
        var bestDur = releaseTimes(0)
        for (i <- 1 until releaseTimes.length) {
            val dur = releaseTimes(i) - releaseTimes(i - 1)
            if (dur > bestDur || (dur == bestDur && keysPressed.charAt(i) > best)) {
                bestDur = dur
                best = keysPressed.charAt(i)
            }
        }
        best
    }
}
