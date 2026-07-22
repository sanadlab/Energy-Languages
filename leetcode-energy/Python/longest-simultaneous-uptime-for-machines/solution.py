class Solution:
    def maxRunTime(self, n: int, batteries: list[int]) -> int:
        total_power = sum(batteries)
        left, right = 1, total_power // n
        
        def can_run(t: int) -> bool:
            # Calculate total power that can contribute up to t minutes per machine
            power_sum = 0
            for b in batteries:
                power_sum += min(b, t)
                if power_sum >= t * n:
                    return True
            return False
        
        while left < right:
            mid = (left + right + 1) // 2
            if can_run(mid):
                left = mid
            else:
                right = mid - 1
        
        return left
