class Solution {
    function slowestKey($releaseTimes, $keysPressed) {
        $n = count($releaseTimes);
        $best = $keysPressed[0];
        $bestDur = $releaseTimes[0];
        for ($i = 1; $i < $n; $i++) {
            $dur = $releaseTimes[$i] - $releaseTimes[$i - 1];
            if ($dur > $bestDur || ($dur == $bestDur && $keysPressed[$i] > $best)) {
                $bestDur = $dur;
                $best = $keysPressed[$i];
            }
        }
        return $best;
    }
}
