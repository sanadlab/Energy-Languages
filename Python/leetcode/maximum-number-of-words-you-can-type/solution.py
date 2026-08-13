class Solution:
    def canBeTypedWords(self, text: str, brokenLetters: str) -> int:
        return sum(not any(b in word for b in brokenLetters) for word in text.split())