from typing import List

class Solution:
    def average(self, salary: List[int]) -> float:
        min_salary = min(salary)
        max_salary = max(salary)
        total = sum(salary)
        n = len(salary)
        return (total - min_salary - max_salary) / (n - 2)
