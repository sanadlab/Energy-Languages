class Solution {
    function eventualSafeNodes($graph) {
        $n = count($graph);
        if ($n == 0) return [];
        $rev = array_fill(0, $n, []);
        $outdeg = array_fill(0, $n, 0);
        for ($u = 0; $u < $n; $u++) {
            $neighbors = is_array($graph[$u]) ? $graph[$u] : [];
            foreach ($neighbors as $v) {
                if ($v >= 0 && $v < $n) {
                    $rev[$v][] = $u;
                    $outdeg[$u]++;
                }
            }
        }
        $queue = [];
        for ($i = 0; $i < $n; $i++) {
            if ($outdeg[$i] == 0) $queue[] = $i;
        }
        $safe = array_fill(0, $n, false);
        $head = 0;
        while ($head < count($queue)) {
            $v = $queue[$head++];
            $safe[$v] = true;
            foreach ($rev[$v] as $u) {
                $outdeg[$u]--;
                if ($outdeg[$u] == 0) $queue[] = $u;
            }
        }
        $res = [];
        for ($i = 0; $i < $n; $i++) {
            if ($safe[$i]) $res[] = $i;
        }
        return $res;
    }
}
