from collections import Counter

class Solution:
    def uncommonFromSentences(self, s1: str, s2: str) -> list[str]:
        # Combine both sentences and split into words
        all_words = (s1 + " " + s2).split()
        
        # Count the occurrences of each word
        word_count = Counter(all_words)
        
        # Filter words that appear exactly once
        uncommon_words = [word for word, count in word_count.items() if count == 1]
        
        return uncommon_words