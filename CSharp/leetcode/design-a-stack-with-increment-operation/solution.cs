public class CustomStack {
    private int maxSize;
    private List<int> stk = new List<int>();
    private List<int> inc = new List<int>();
    public CustomStack(int maxSize) { this.maxSize = maxSize; }
    public void Push(int x) {
        if (stk.Count < maxSize) { stk.Add(x); inc.Add(0); }
    }
    public int Pop() {
        if (stk.Count == 0) return -1;
        int i = stk.Count - 1;
        int v = stk[i] + inc[i];
        if (i > 0) inc[i - 1] += inc[i];
        stk.RemoveAt(i); inc.RemoveAt(i);
        return v;
    }
    public void Increment(int k, int val) {
        int i = Math.Min(k, stk.Count) - 1;
        if (i >= 0) inc[i] += val;
    }
}
