class CustomStack {
    private int maxSize;
    private int[] stk;
    private int[] inc;
    private int size;
    public CustomStack(int maxSize) {
        this.maxSize = maxSize;
        stk = new int[Math.max(maxSize, 1)];
        inc = new int[Math.max(maxSize, 1)];
        size = 0;
    }
    public void push(int x) {
        if (size < maxSize) { stk[size] = x; inc[size] = 0; size++; }
    }
    public int pop() {
        if (size == 0) return -1;
        int i = size - 1;
        int v = stk[i] + inc[i];
        if (i > 0) inc[i - 1] += inc[i];
        size--;
        return v;
    }
    public void increment(int k, int val) {
        int i = Math.min(k, size) - 1;
        if (i >= 0) inc[i] += val;
    }
}
