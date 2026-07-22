class Solution:
    def isSumEqual(self, firstWord: str, secondWord: str, targetWord: str) -> bool:
        def word_to_num(word: str) -> int:
            return int("".join(str(ord(c) - ord('a')) for c in word))
        
        return word_to_num(firstWord) + word_to_num(secondWord) == word_to_num(targetWord)
