from typing import List

class Solution:
    def minSessions(self, tasks: List[int], sessionTime: int) -> int:
        n = len(tasks)
        full = (1 << n) - 1
        INF = float('inf')
        sessions = [INF] * (1 << n)
        used = [0] * (1 << n)
        sessions[0] = 1
        for mask in range(full + 1):
            if sessions[mask] == INF:
                continue
            for i in range(n):
                if mask & (1 << i):
                    continue
                nm = mask | (1 << i)
                if used[mask] + tasks[i] <= sessionTime:
                    ns = sessions[mask]
                    nu = used[mask] + tasks[i]
                else:
                    ns = sessions[mask] + 1
                    nu = tasks[i]
                if ns < sessions[nm] or (ns == sessions[nm] and nu < used[nm]):
                    sessions[nm] = ns
                    used[nm] = nu
        return sessions[full]
