class Solution {

    /**
     * @param String $s
     * @return Integer
     */
    function removePalindromeSub($s) {
        if ($s === "") return 0;
        return $s === strrev($s) ? 1 : 2;
    }
}
