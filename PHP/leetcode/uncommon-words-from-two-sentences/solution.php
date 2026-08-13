class Solution {
    function uncommonFromSentences($s1, $s2) {
        $cnt = [];
        foreach (array_merge(explode(" ", $s1), explode(" ", $s2)) as $w) {
            if ($w === "") continue;
            $cnt[$w] = ($cnt[$w] ?? 0) + 1;
        }
        $res = [];
        foreach ($cnt as $w => $c) if ($c === 1) $res[] = $w;
        return $res;
    }
}
