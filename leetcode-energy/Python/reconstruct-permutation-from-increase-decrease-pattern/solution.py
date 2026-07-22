class Solution:
    def diStringMatch(self, s: str) -> list[int]:
        low, high = 0, len(s)
        result = []
        for c in s:
            if c == 'I':
                result.append(low)
                low += 1
            else:  # c == 'D'
                result.append(high)
                high -= 1
        result.append(low)  # low == high here
        return result
