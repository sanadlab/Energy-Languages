from collections import Counter

class Solution:
    def closeStrings(self, word1: str, word2: str) -> bool:
        # If lengths differ, they can't be close
        if len(word1) != len(word2):
            return False
        
        # Count frequencies of characters in both words
        count1 = Counter(word1)
        count2 = Counter(word2)
        
        # Operation 2 implies the set of characters must be the same
        if set(count1.keys()) != set(count2.keys()):
            return False
        
        # Operation 1 implies frequency multisets must be the same (order can be changed)
        freq1 = sorted(count1.values())
        freq2 = sorted(count2.values())
        
        return freq1 == freq2
