from typing import List
from collections import deque

class Solution:
    def maxTaskAssign(self, tasks: List[int], workers: List[int], pills: int, strength: int) -> int:
        tasks.sort()
        workers.sort()
        n, m = len(tasks), len(workers)

        def can(k: int) -> bool:
            available = deque()
            i = 0
            used_pills = 0

            for w in workers[m - k:]:
                while i < k and tasks[i] <= w + strength:
                    available.append(tasks[i])
                    i += 1

                if not available:
                    return False

                if available[0] <= w:
                    available.popleft()
                else:
                    used_pills += 1
                    if used_pills > pills:
                        return False
                    available.pop()

            return True

        left, right = 0, min(n, m)
        while left < right:
            mid = (left + right + 1) // 2
            if can(mid):
                left = mid
            else:
                right = mid - 1

        return left
