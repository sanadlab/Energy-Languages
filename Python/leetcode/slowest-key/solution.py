class Solution:
    def slowestKey(self, releaseTimes, keysPressed):
        best = keysPressed[0]
        best_dur = releaseTimes[0]
        for i in range(1, len(releaseTimes)):
            dur = releaseTimes[i] - releaseTimes[i - 1]
            if dur > best_dur or (dur == best_dur and keysPressed[i] > best):
                best_dur = dur
                best = keysPressed[i]
        return best
