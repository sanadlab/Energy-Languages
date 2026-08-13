class Solution {
    function kWeakestRows($mat, $k) {
        $rows = [];
        foreach ($mat as $i => $row) {
            $c = 0;
            foreach ($row as $v) if ($v === 1) $c++;
            $rows[] = [$c, $i];
        }
        usort($rows, function($a, $b) {
            return $a[0] === $b[0] ? $a[1] - $b[1] : $a[0] - $b[0];
        });
        $lim = min($k, count($rows));
        $res = [];
        for ($i = 0; $i < $lim; $i++) $res[] = $rows[$i][1];
        return $res;
    }
}
