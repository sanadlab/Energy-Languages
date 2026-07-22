class Solution:
    def clumsy(self, n: int) -> int:
        stack = [n]
        op = 0

        for x in range(n - 1, 0, -1):
            if op == 0:
                stack[-1] *= x
            elif op == 1:
                stack[-1] = int(stack[-1] / x)
            elif op == 2:
                stack.append(x)
            else:
                stack.append(-x)

            op = (op + 1) % 4

        return sum(stack)
