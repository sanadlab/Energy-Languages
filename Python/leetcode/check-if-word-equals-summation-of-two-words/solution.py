class Solution:
    def isSumEqual(self, firstWord: str, secondWord: str, targetWord: str) -> bool:
        def word_to_num(word):
            num = 0
            for char in word:
                num = num * 10 + (ord(char) - ord('a'))
            return num
        
        return word_to_num(firstWord) + word_to_num(secondWord) == word_to_num(targetWord)