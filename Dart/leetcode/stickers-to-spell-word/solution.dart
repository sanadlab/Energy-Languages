class Solution {
  int minStickers(List<String> stickers, String target) {
    int n = target.length;
    int full = (1 << n) - 1;
    const int INF = 1 << 60;
    List<int> dp = List<int>.filled(1 << n, INF);
    dp[0] = 0;
    List<List<int>> cnt = [];
    for (String s in stickers) {
      List<int> c = List<int>.filled(26, 0);
      for (int i = 0; i < s.length; i++) {
        c[s.codeUnitAt(i) - 97] += 1;
      }
      cnt.add(c);
    }
    List<int> targetIdx = List<int>.filled(n, 0);
    for (int i = 0; i < n; i++) {
      targetIdx[i] = target.codeUnitAt(i) - 97;
    }
    for (int state = 0; state < (1 << n); state++) {
      if (dp[state] == INF) {
        continue;
      }
      for (List<int> c in cnt) {
        List<int> avail = List<int>.from(c);
        int nxt = state;
        for (int i = 0; i < n; i++) {
          if ((state & (1 << i)) == 0) {
            int idx = targetIdx[i];
            if (avail[idx] > 0) {
              avail[idx] -= 1;
              nxt |= (1 << i);
            }
          }
        }
        if (dp[state] + 1 < dp[nxt]) {
          dp[nxt] = dp[state] + 1;
        }
      }
    }
    return dp[full] == INF ? -1 : dp[full];
  }
}
