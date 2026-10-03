class Solution {
    func slowestKey(_ releaseTimes: [Int], _ keysPressed: String) -> Character {
        let keys = Array(keysPressed)
        var best = keys[0]
        var bestDur = releaseTimes[0]
        for i in 1..<releaseTimes.count {
            let dur = releaseTimes[i] - releaseTimes[i - 1]
            if dur > bestDur || (dur == bestDur && keys[i] > best) {
                bestDur = dur
                best = keys[i]
            }
        }
        return best
    }
}
