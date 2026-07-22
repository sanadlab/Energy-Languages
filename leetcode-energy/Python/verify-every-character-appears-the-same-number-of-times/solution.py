class Solution:
    def areOccurrencesEqual(self, s: str) -> bool:
        from collections import Counter
        freq = Counter(s)
        counts = list(freq.values())
        return len(set(counts)) == 1
