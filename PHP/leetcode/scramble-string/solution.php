class Solution {

    /**
     * @param String $s1
     * @param String $s2
     * @return Boolean
     */
    function isScramble($s1, $s2) {
        $len = strlen($s1);
        if ($s1 === $s2) return true;
        if (count_chars($s1, 1) != count_chars($s2, 1)) return false;

        $memo = [];
        return $this->dfs($s1, $s2, $memo);
    }

    private function dfs($s1, $s2, &$memo) {
        if ($s1 === $s2) return true;
        $key = $s1 . '#' . $s2;
        if (isset($memo[$key])) return $memo[$key];

        if (count_chars($s1, 1) != count_chars($s2, 1)) {
            $memo[$key] = false;
            return false;
        }

        $n = strlen($s1);
        for ($i = 1; $i < $n; $i++) {
            // Case 1: no swap
            if ($this->dfs(substr($s1, 0, $i), substr($s2, 0, $i), $memo) &&
                $this->dfs(substr($s1, $i), substr($s2, $i), $memo)) {
                $memo[$key] = true;
                return true;
            }
            // Case 2: swap
            if ($this->dfs(substr($s1, 0, $i), substr($s2, $n - $i), $memo) &&
                $this->dfs(substr($s1, $i), substr($s2, 0, $n - $i), $memo)) {
                $memo[$key] = true;
                return true;
            }
        }

        $memo[$key] = false;
        return false;
    }
}