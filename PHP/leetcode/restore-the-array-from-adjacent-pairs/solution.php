class Solution {

    /**
     * @param Integer[][] $adjacentPairs
     * @return Integer[]
     */
    function restoreArray($adjacentPairs) {
        $adj = [];
        foreach ($adjacentPairs as $p) {
            $adj[$p[0]][] = $p[1];
            $adj[$p[1]][] = $p[0];
        }
        $n = count($adjacentPairs) + 1;
        $start = count($adjacentPairs) > 0 ? $adjacentPairs[0][0] : 0;
        foreach ($adj as $node => $nbrs) {
            if (count($nbrs) === 1) { $start = $node; break; }
        }
        $res = [$start];
        $prev = $start; $cur = $start; $hasPrev = false;
        while (count($res) < $n) {
            $nxt = null;
            if (isset($adj[$cur])) {
                foreach ($adj[$cur] as $x) {
                    if (!$hasPrev || $x !== $prev) { $nxt = $x; break; }
                }
            }
            if ($nxt === null) break;
            $res[] = $nxt;
            $prev = $cur; $hasPrev = true; $cur = $nxt;
        }
        return $res;
    }
}
