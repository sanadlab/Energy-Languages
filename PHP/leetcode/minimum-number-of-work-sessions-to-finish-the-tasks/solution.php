class Solution {
    function minSessions($tasks, $sessionTime) {
        $n = count($tasks);
        $full = (1 << $n) - 1;
        $INF = 1000000000;
        $sessions = array_fill(0, 1 << $n, $INF);
        $used = array_fill(0, 1 << $n, 0);
        $sessions[0] = 1;
        for ($mask = 0; $mask <= $full; $mask++) {
            if ($sessions[$mask] === $INF) continue;
            for ($i = 0; $i < $n; $i++) {
                if ($mask & (1 << $i)) continue;
                $nm = $mask | (1 << $i);
                if ($used[$mask] + $tasks[$i] <= $sessionTime) {
                    $ns = $sessions[$mask];
                    $nu = $used[$mask] + $tasks[$i];
                } else {
                    $ns = $sessions[$mask] + 1;
                    $nu = $tasks[$i];
                }
                if ($ns < $sessions[$nm] || ($ns === $sessions[$nm] && $nu < $used[$nm])) {
                    $sessions[$nm] = $ns;
                    $used[$nm] = $nu;
                }
            }
        }
        return $sessions[$full];
    }
}
