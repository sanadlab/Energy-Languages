class Solution:
    def rotatingOperatorProduct(self, n: int) -> int:
        # Operators cycle: '*', '/', '+', '-'
        ops = ['*', '/', '+', '-']
        
        # Step 1: Build the expression as a list of tokens (numbers and operators)
        tokens = []
        for i in range(n, 0, -1):
            tokens.append(i)
            if i > 1:
                op = ops[(n - i) % 4]
                tokens.append(op)
        
        # Step 2: Evaluate all * and / from left to right (floor division)
        stack = []
        i = 0
        while i < len(tokens):
            token = tokens[i]
            if isinstance(token, int):
                stack.append(token)
                i += 1
            else:
                # token is operator
                if token == '*':
                    # multiply top of stack with next number
                    i += 1
                    val = tokens[i]
                    stack[-1] = stack[-1] * val
                    i += 1
                elif token == '/':
                    # floor divide top of stack by next number
                    i += 1
                    val = tokens[i]
                    stack[-1] = stack[-1] // val
                    i += 1
                else:
                    # '+' or '-' operators, just push them for now
                    stack.append(token)
                    i += 1
        
        # Step 3: Evaluate + and - from left to right
        result = stack[0]
        i = 1
        while i < len(stack):
            op = stack[i]
            val = stack[i+1]
            if op == '+':
                result += val
            else:  # op == '-'
                result -= val
            i += 2
        
        return result
