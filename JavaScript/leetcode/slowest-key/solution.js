var slowestKey = function(releaseTimes, keysPressed) {
    let best = keysPressed[0];
    let bestDur = releaseTimes[0];
    for (let i = 1; i < releaseTimes.length; i++) {
        const dur = releaseTimes[i] - releaseTimes[i - 1];
        if (dur > bestDur || (dur === bestDur && keysPressed[i] > best)) {
            bestDur = dur;
            best = keysPressed[i];
        }
    }
    return best;
};
