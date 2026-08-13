class Solution {
    /**
     * @param String $text
     * @param String $brokenLetters
     * @return Integer
     */
    function canBeTypedWords($text, $brokenLetters) {
        $broken = array_flip(str_split($brokenLetters === '' ? '' : $brokenLetters));
        if ($brokenLetters === '') $broken = [];
        $count = 0;
        foreach (explode(' ', $text) as $word) {
            $ok = true;
            $len = strlen($word);
            for ($i = 0; $i < $len; $i++) {
                if (isset($broken[$word[$i]])) { $ok = false; break; }
            }
            if ($ok) $count++;
        }
        return $count;
    }
}
