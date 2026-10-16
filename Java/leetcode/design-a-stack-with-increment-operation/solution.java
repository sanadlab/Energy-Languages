import java.util.*;
import java.util.stream.*;
import java.math.*;

class CustomStack {
    private final int[] stack;
    private final int[] inc;   // lazy increment, pushed down on pop
    private int top = 0;

    public CustomStack(int maxSize) {
        stack = new int[maxSize];
        inc = new int[maxSize];
    }

    public void push(int x) {
        if (top < stack.length) stack[top++] = x;
    }

    public int pop() {
        if (top == 0) return -1;
        int i = --top;
        int v = stack[i] + inc[i];
        if (i > 0) inc[i - 1] += inc[i];
        inc[i] = 0;
        return v;
    }

    public void increment(int k, int val) {
        int i = Math.min(k, top) - 1;
        if (i >= 0) inc[i] += val;
    }
}
