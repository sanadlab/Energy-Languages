class Solution {
    private $parent;

    private function find($x) {
        while ($this->parent[$x] !== $x) {
            $this->parent[$x] = $this->parent[$this->parent[$x]];
            $x = $this->parent[$x];
        }
        return $x;
    }

    /**
     * @param Integer $n
     * @param Integer[][] $restrictions
     * @param Integer[][] $requests
     * @return Boolean[]
     */
    function friendRequests($n, $restrictions, $requests) {
        $this->parent = range(0, $n - 1);
        $res = array();
        foreach ($requests as $req) {
            $u = $req[0];
            $v = $req[1];
            $pu = $this->find($u);
            $pv = $this->find($v);
            if ($pu === $pv) { $res[] = true; continue; }
            $ok = true;
            foreach ($restrictions as $r) {
                $px = $this->find($r[0]);
                $py = $this->find($r[1]);
                if (($px === $pu && $py === $pv) || ($px === $pv && $py === $pu)) { $ok = false; break; }
            }
            if ($ok) { $this->parent[$pu] = $pv; $res[] = true; }
            else { $res[] = false; }
        }
        return $res;
    }
}
