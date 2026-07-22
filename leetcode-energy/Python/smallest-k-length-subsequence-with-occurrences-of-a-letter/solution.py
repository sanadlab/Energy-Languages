class Solution:
    def smallestSubsequence(self, s: str, k: int, letter: str, repetition: int) -> str:
        n = len(s)
        remaining = s.count(letter)
        stack = []
        in_stack = 0

        for i, ch in enumerate(s):
            while (
                stack
                and stack[-1] > ch
                and len(stack) - 1 + (n - i) >= k
                and (stack[-1] != letter or in_stack - 1 + remaining >= repetition)
            ):
                removed = stack.pop()
                if removed == letter:
                    in_stack -= 1

            if len(stack) < k:
                if ch == letter:
                    stack.append(ch)
                    in_stack += 1
                elif k - len(stack) > repetition - in_stack:
                    stack.append(ch)

            if ch == letter:
                remaining -= 1

        return "".join(stack)
