class Solution {
  int minSessions(List<int> tasks, int sessionTime) {
    int n = tasks.length;
    int full = (1 << n) - 1;
    int inf = 1 << 60;
    List<int> sessions = List<int>.filled(1 << n, inf);
    List<int> used = List<int>.filled(1 << n, 0);
    sessions[0] = 1;
    for (int mask = 0; mask <= full; mask++) {
      if (sessions[mask] == inf) continue;
      for (int i = 0; i < n; i++) {
        if ((mask & (1 << i)) != 0) continue;
        int nm = mask | (1 << i);
        int ns, nu;
        if (used[mask] + tasks[i] <= sessionTime) {
          ns = sessions[mask];
          nu = used[mask] + tasks[i];
        } else {
          ns = sessions[mask] + 1;
          nu = tasks[i];
        }
        if (ns < sessions[nm] || (ns == sessions[nm] && nu < used[nm])) {
          sessions[nm] = ns;
          used[nm] = nu;
        }
      }
    }
    return sessions[full];
  }
}
