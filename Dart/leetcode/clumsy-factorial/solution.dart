class Solution {
  int clumsy(int n) {
    List<int> stack = [n];
    int op = 0;
    for (int x = n - 1; x > 0; x--) {
      if (op == 0) {
        stack.add(stack.removeLast() * x);
      } else if (op == 1) {
        int top = stack.removeLast();
        stack.add(top ~/ x);
      } else if (op == 2) {
        stack.add(x);
      } else {
        stack.add(-x);
      }
      op = (op + 1) % 4;
    }
    int sum = 0;
    for (int v in stack) {
      sum += v;
    }
    return sum;
  }
}
