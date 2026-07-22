from typing import List

class Solution:
    def minimumTimeRequired(self, jobs: List[int], k: int) -> int:
        jobs.sort(reverse=True)
        n = len(jobs)
        
        if k >= n:
            return jobs[0]
        
        left = max(jobs)
        right = sum(jobs)
        
        def can_finish(limit: int) -> bool:
            workers = [0] * k
            
            def dfs(i: int) -> bool:
                if i == n:
                    return True
                
                job = jobs[i]
                seen = set()
                
                for w in range(k):
                    if workers[w] in seen:
                        continue
                    if workers[w] + job <= limit:
                        seen.add(workers[w])
                        workers[w] += job
                        
                        if dfs(i + 1):
                            return True
                        
                        workers[w] -= job
                
                return False
            
            return dfs(0)
        
        while left < right:
            mid = (left + right) // 2
            if can_finish(mid):
                right = mid
            else:
                left = mid + 1
        
        return left
