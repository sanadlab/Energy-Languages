class Solution:
    def areOccurrencesEqual(self, s: str) -> bool:
        from collections import Counter
        
        counts = Counter(s).values()
        return len(set(counts)) == 1