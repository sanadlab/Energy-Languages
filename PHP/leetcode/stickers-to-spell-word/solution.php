class Solution {
    function minStickers($stickers, $target) {
        $n = strlen($target);
        $full = (1 << $n) - 1;
        $INF = PHP_INT_MAX;
        $dp = array_fill(0, 1 << $n, $INF);
        $dp[0] = 0;
        $m = count($stickers);
        $cnt = array();
        for ($j = 0; $j < $m; $j++) {
            $c = array_fill(0, 26, 0);
            $len = strlen($stickers[$j]);
            for ($x = 0; $x < $len; $x++) {
                $c[ord($stickers[$j][$x]) - 97]++;
            }
            $cnt[$j] = $c;
        }
        for ($state = 0; $state <= $full; $state++) {
            if ($dp[$state] === $INF) continue;
            for ($j = 0; $j < $m; $j++) {
                $avail = $cnt[$j];
                $nxt = $state;
                for ($i = 0; $i < $n; $i++) {
                    if (($state & (1 << $i)) === 0) {
                        $c = ord($target[$i]) - 97;
                        if ($avail[$c] > 0) { $avail[$c]--; $nxt |= (1 << $i); }
                    }
                }
                if ($dp[$state] + 1 < $dp[$nxt]) $dp[$nxt] = $dp[$state] + 1;
            }
        }
        return $dp[$full] === $INF ? -1 : $dp[$full];
    }
}
