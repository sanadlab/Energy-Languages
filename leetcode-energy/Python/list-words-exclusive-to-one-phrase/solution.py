from collections import Counter

class Solution:
    def uncommonFromSentences(self, s1: str, s2: str) -> list[str]:
        count1 = Counter(s1.split())
        count2 = Counter(s2.split())
        
        result = []
        for word, cnt in count1.items():
            if cnt == 1 and word not in count2:
                result.append(word)
        for word, cnt in count2.items():
            if cnt == 1 and word not in count1:
                result.append(word)
        return result
