public class Solution {
    public int Clumsy(int n) {
        if (n == 1) return 1;
        if (n == 2) return 2;
        if (n == 3) return 6;
        if (n == 4) return 7;

        // For n >= 5, pattern emerges:
        // clumsy(n) = n * (n-1) / (n-2) + (n-3) - clumsy(n-4)
        // But to avoid recursion, use a stack to simulate the operations.

        var stack = new Stack<int>();
        stack.Push(n);
        n--;
        int index = 0; // 0: *, 1: /, 2: +, 3: -

        while (n > 0) {
            if (index % 4 == 0) {
                // multiply
                int top = stack.Pop();
                stack.Push(top * n);
            } else if (index % 4 == 1) {
                // divide (floor division)
                int top = stack.Pop();
                stack.Push(top / n);
            } else if (index % 4 == 2) {
                // add
                stack.Push(n);
            } else {
                // subtract
                stack.Push(-n);
            }
            index++;
            n--;
        }

        int result = 0;
        while (stack.Count > 0) {
            result += stack.Pop();
        }
        return result;
    }
}