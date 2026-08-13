class Solution {
    function numSmallerByFrequency($queries, $words) {
        $wf = array();
        foreach ($words as $w) { $wf[] = $this->f($w); }
        $ans = array();
        foreach ($queries as $q) {
            $fq = $this->f($q);
            $c = 0;
            foreach ($wf as $v) { if ($v > $fq) { $c++; } }
            $ans[] = $c;
        }
        return $ans;
    }
    private function f($s) {
        $mn = 'z'; $cnt = 0;
        for ($i = 0; $i < strlen($s); $i++) {
            $c = $s[$i];
            if ($c < $mn) { $mn = $c; $cnt = 1; }
            else if ($c == $mn) { $cnt++; }
        }
        return $cnt;
    }
}
