import java.util.ArrayDeque;
import java.util.Deque;

class Solution {
    public int clumsy(int n) {
        Deque<Integer> stack = new ArrayDeque<>();
        stack.push(n);
        int op = 0;
        for (int x = n - 1; x > 0; x--) {
            if (op == 0) {
                stack.push(stack.pop() * x);
            } else if (op == 1) {
                stack.push(stack.pop() / x);
            } else if (op == 2) {
                stack.push(x);
            } else {
                stack.push(-x);
            }
            op = (op + 1) % 4;
        }
        int sum = 0;
        for (int v : stack) {
            sum += v;
        }
        return sum;
    }
}
