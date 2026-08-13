class Solution:
    def minSwaps(self, s: str) -> int:
        open_ = 0
        for c in s:
            if c == '[':
                open_ += 1
            elif open_ > 0:
                open_ -= 1
        return (open_ + 1) // 2
