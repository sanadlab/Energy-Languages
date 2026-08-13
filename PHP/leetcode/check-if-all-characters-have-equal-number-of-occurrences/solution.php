class Solution {

    /**
     * @param String $s
     * @return Boolean
     */
    function areOccurrencesEqual($s) {
        $cnt = array_count_values(str_split($s));
        $vals = array_values($cnt);
        $first = $vals[0];
        foreach ($vals as $v) {
            if ($v !== $first) return false;
        }
        return true;
    }
}
