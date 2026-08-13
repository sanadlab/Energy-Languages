class Solution {

    private function valid($st) {
        $cnt = 0;
        $len = strlen($st);
        for ($i = 0; $i < $len; $i++) {
            $ch = $st[$i];
            if ($ch === '(') $cnt++;
            elseif ($ch === ')') { $cnt--; if ($cnt < 0) return false; }
        }
        return $cnt === 0;
    }

    /**
     * @param String $s
     * @return String[]
     */
    function removeInvalidParentheses($s) {
        $level = [$s => true];
        while (count($level) > 0) {
            $valids = [];
            foreach ($level as $st => $ignore) if ($this->valid((string)$st)) $valids[] = (string)$st;
            if (count($valids) > 0) return $valids;
            $nxt = [];
            foreach ($level as $st => $ignore) {
                $st = (string)$st;
                $len = strlen($st);
                for ($i = 0; $i < $len; $i++) {
                    if ($st[$i] === '(' || $st[$i] === ')') {
                        $nxt[substr($st, 0, $i) . substr($st, $i + 1)] = true;
                    }
                }
            }
            $level = $nxt;
        }
        return [""];
    }
}
