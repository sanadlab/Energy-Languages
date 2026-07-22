from typing import List
from bisect import bisect_right

class Solution:
    def numSmallerByFrequency(self, queries: List[str], words: List[str]) -> List[int]:
        def f(s: str) -> int:
            smallest = min(s)
            return s.count(smallest)
        
        word_freqs = sorted(f(word) for word in words)
        n = len(word_freqs)
        
        return [n - bisect_right(word_freqs, f(query)) for query in queries]
