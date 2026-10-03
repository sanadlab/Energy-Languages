class CustomStack {
  late int maxSize;
  List<int> stack = [];
  List<int> inc = [];

  CustomStack(int maxSize) {
    this.maxSize = maxSize;
  }

  void push(int x) {
    if (stack.length < maxSize) {
      stack.add(x);
      inc.add(0);
    }
  }

  int pop() {
    if (stack.isEmpty) return -1;
    int i = stack.length - 1;
    int v = stack[i] + inc[i];
    if (i > 0) {
      inc[i - 1] += inc[i];
    }
    stack.removeLast();
    inc.removeLast();
    return v;
  }

  void increment(int k, int val) {
    int i = (k < stack.length ? k : stack.length) - 1;
    if (i >= 0) {
      inc[i] += val;
    }
  }
}

/**
 * Your CustomStack object will be instantiated and called as such:
 * CustomStack obj = CustomStack(maxSize);
 * obj.push(x);
 * int param2 = obj.pop();
 * obj.increment(k,val);
 */
