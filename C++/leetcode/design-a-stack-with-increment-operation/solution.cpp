class CustomStack {
    int maxSize;
    vector<int> stk;
    vector<int> inc;
public:
    CustomStack(int maxSize) : maxSize(maxSize) {}
    void push(int x) {
        if ((int)stk.size() < maxSize) { stk.push_back(x); inc.push_back(0); }
    }
    int pop() {
        if (stk.empty()) return -1;
        int i = (int)stk.size() - 1;
        int v = stk[i] + inc[i];
        if (i > 0) inc[i - 1] += inc[i];
        stk.pop_back(); inc.pop_back();
        return v;
    }
    void increment(int k, int val) {
        int i = min(k, (int)stk.size()) - 1;
        if (i >= 0) inc[i] += val;
    }
};
