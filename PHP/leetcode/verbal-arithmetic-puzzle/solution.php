class Solution {

    private $assigned;
    private $used;
    private $leading;
    private $words;
    private $result;
    private $maxLen;

    /**
     * @param String[] $words
     * @param String $result
     * @return Boolean
     */
    function isSolvable($words, $result) {
        $this->maxLen = strlen($result);
        foreach ($words as $w) if (strlen($w) > $this->maxLen) return false;
        $this->assigned = array_fill(0, 128, -1);
        $this->used = array_fill(0, 10, false);
        $this->leading = array_fill(0, 128, false);
        foreach ($words as $w) if (strlen($w) > 1) $this->leading[ord($w[0])] = true;
        if (strlen($result) > 1) $this->leading[ord($result[0])] = true;
        $this->words = $words;
        $this->result = $result;
        return $this->solve(0, 0, 0);
    }

    private function solve($col, $row, $carry) {
        if ($col == $this->maxLen) return $carry == 0;
        if ($row < count($this->words)) {
            $w = $this->words[$row];
            if ($col >= strlen($w)) return $this->solve($col, $row + 1, $carry);
            $ch = ord($w[strlen($w) - 1 - $col]);
            if ($this->assigned[$ch] != -1) return $this->solve($col, $row + 1, $carry);
            for ($d = 0; $d <= 9; $d++) {
                if (!$this->used[$d] && !($d == 0 && $this->leading[$ch])) {
                    $this->used[$d] = true;
                    $this->assigned[$ch] = $d;
                    if ($this->solve($col, $row + 1, $carry)) return true;
                    $this->used[$d] = false;
                    $this->assigned[$ch] = -1;
                }
            }
            return false;
        }
        $s = $carry;
        foreach ($this->words as $w)
            if ($col < strlen($w)) $s += $this->assigned[ord($w[strlen($w) - 1 - $col])];
        $digit = $s % 10;
        $nc = intdiv($s, 10);
        $rch = ord($this->result[strlen($this->result) - 1 - $col]);
        if ($this->assigned[$rch] != -1) {
            if ($this->assigned[$rch] == $digit) return $this->solve($col + 1, 0, $nc);
            return false;
        }
        if ($this->used[$digit]) return false;
        if ($digit == 0 && $this->leading[$rch]) return false;
        $this->used[$digit] = true;
        $this->assigned[$rch] = $digit;
        if ($this->solve($col + 1, 0, $nc)) return true;
        $this->used[$digit] = false;
        $this->assigned[$rch] = -1;
        return false;
    }
}
