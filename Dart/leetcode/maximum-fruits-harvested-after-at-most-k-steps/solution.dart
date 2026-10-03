class Solution {
  int maxTotalFruits(List<List<int>> fruits, int startPos, int k) {
    int n = fruits.length;
    int best = 0;
    int total = 0;
    int i = 0;
    for (int j = 0; j < n; j++) {
      total += fruits[j][1];
      while (i <= j && _cost(fruits[i][0], fruits[j][0], startPos) > k) {
        total -= fruits[i][1];
        i++;
      }
      if (i <= j && total > best) best = total;
    }
    return best;
  }

  int _cost(int posL, int posR, int startPos) {
    if (posR <= startPos) return startPos - posL;
    if (posL >= startPos) return posR - startPos;
    int a = startPos - posL;
    int b = posR - startPos;
    return (posR - posL) + (a < b ? a : b);
  }
}
