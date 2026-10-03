char slowestKey(int* releaseTimes, int releaseTimesSize, char* keysPressed) {
    char best = keysPressed[0];
    int best_dur = releaseTimes[0];
    for (int i = 1; i < releaseTimesSize; i++) {
        int dur = releaseTimes[i] - releaseTimes[i - 1];
        if (dur > best_dur || (dur == best_dur && keysPressed[i] > best)) {
            best_dur = dur;
            best = keysPressed[i];
        }
    }
    return best;
}
