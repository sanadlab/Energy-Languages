class Solution:
    def removePalindromeSub(self, s: str) -> int:
        # If the string is already a palindrome, only one step is needed.
        if s == s[::-1]:
            return 1
        # Otherwise, since s consists only of 'a' and 'b',
        # we can remove all 'a's in one step and all 'b's in another step.
        return 2
