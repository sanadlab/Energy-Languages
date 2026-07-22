from typing import List

class Solution:
    def longestStrChain(self, words: List[str]) -> int:
        words.sort(key=len)
        dp = {}
        max_chain = 1
        
        for word in words:
            dp[word] = 1
            # Try removing one character from word to find a predecessor
            for i in range(len(word)):
                pred = word[:i] + word[i+1:]
                if pred in dp:
                    dp[word] = max(dp[word], dp[pred] + 1)
            max_chain = max(max_chain, dp[word])
        
        return max_chain
