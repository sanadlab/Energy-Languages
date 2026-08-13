class Solution {
    public function arrayStringsAreEqual($word1, $word2) {
        return implode('', $word1) === implode('', $word2);
    }
}