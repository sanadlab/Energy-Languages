public class CustomStack {
    private int[] data;
    private int[] inc;
    private int top;
    private int cap;

    public CustomStack(int maxSize) {
        cap = maxSize;
        data = new int[maxSize];
        inc = new int[maxSize];
        top = 0;
    }
    
    public void Push(int x) {
        if (top < cap) {
            data[top] = x;
            inc[top] = 0;
            top++;
        }
    }
    
    public int Pop() {
        if (top == 0) return -1;
        top--;
        int result = data[top] + inc[top];
        if (top > 0) {
            inc[top - 1] += inc[top];
        }
        inc[top] = 0;
        return result;
    }
    
    public void Increment(int k, int val) {
        if (top == 0) return;
        int idx = Math.Min(k, top) - 1;
        inc[idx] += val;
    }
}

/**
 * Your CustomStack object will be instantiated and called as such:
 * CustomStack obj = new CustomStack(maxSize);
 * obj.Push(x);
 * int param_2 = obj.Pop();
 * obj.Increment(k,val);
 */