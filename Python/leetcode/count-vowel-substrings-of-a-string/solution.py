class Solution:
    def countVowelSubstrings(self, word: str) -> int:
        # Helper function to check if a substring contains all vowels
        def has_all_vowels(sub):
            return 'a' in sub and 'e' in sub and 'i' in sub and 'o' in sub and 'u' in sub
        
        count = 0
        n = len(word)
        
        # Iterate through the string to find valid starting points for substrings
        for i in range(n):
            if word[i] not in "aeiou":
                continue
            seen_vowels = set()
            j = i
            while j < n and word[j] in "aeiou":
                seen_vowels.add(word[j])
                # Check if the current substring contains all vowels
                if len(seen_vowels) == 5:
                    count += 1
                j += 1
        
        return count