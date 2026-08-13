class Solution:
    def clumsy(self, n: int) -> int:
        stack = [n]
        op = 0
        for x in range(n - 1, 0, -1):
            if op == 0:
                stack.append(stack.pop() * x)
            elif op == 1:
                top = stack.pop()
                stack.append(int(top / x))
            elif op == 2:
                stack.append(x)
            else:
                stack.append(-x)
            op = (op + 1) % 4
        return sum(stack)
