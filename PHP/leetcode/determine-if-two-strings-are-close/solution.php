class Solution {
    public function closeStrings(string $word1, string $word2): bool {
        if (strlen($word1) != strlen($word2)) {
            return false;
        }
        
        $counts1 = [];
        $counts2 = [];
        
        foreach (str_split($word1) as $char) {
            $counts1[$char] = ($counts1[$char] ?? 0) + 1;
        }
        
        foreach (str_split($word2) as $char) {
            $counts2[$char] = ($counts2[$char] ?? 0) + 1;
        }
        
        $keys1 = array_keys($counts1);
        $keys2 = array_keys($counts2);
        
        sort($keys1);
        sort($keys2);
        
        if ($keys1 !== $keys2) {
            return false;
        }
        
        $values1 = array_values($counts1);
        $values2 = array_values($counts2);
        
        sort($values1);
        sort($values2);
        
        return $values1 === $values2;
    }
}