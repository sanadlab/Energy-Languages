class Solution:
    def closeStrings(self, word1: str, word2: str) -> bool:
        # Check if lengths are different
        if len(word1) != len(word2):
            return False
        
        # Count character frequencies in both words
        freq1 = [0] * 26
        freq2 = [0] * 26
        
        for c1, c2 in zip(word1, word2):
            idx1, idx2 = ord(c1) - ord('a'), ord(c2) - ord('a')
            freq1[idx1] += 1
            freq2[idx2] += 1
        
        # Check if both words have the same set of characters
        for i in range(26):
            if (freq1[i] > 0 and not freq2[i]) or (freq2[i] > 0 and not freq1[i]):
                return False
        
        # Check if frequency distributions are the same when ignoring character identities
        from collections import Counter
        return sorted(freq1) == sorted(freq2)