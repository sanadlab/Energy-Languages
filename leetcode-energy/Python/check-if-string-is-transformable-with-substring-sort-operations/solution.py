from collections import deque

class Solution:
    def isTransformable(self, s: str, t: str) -> bool:
        positions = [deque() for _ in range(10)]

        for i, ch in enumerate(s):
            positions[ord(ch) - ord('0')].append(i)

        for ch in t:
            digit = ord(ch) - ord('0')

            if not positions[digit]:
                return False

            pos = positions[digit].popleft()

            for smaller in range(digit):
                if positions[smaller] and positions[smaller][0] < pos:
                    return False

        return True
