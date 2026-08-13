class Solution:
    def average(self, salary):
        mn, mx, total = salary[0], salary[0], 0
        for s in salary:
            total += s
            mn = min(mn, s); mx = max(mx, s)
        return (total - mn - mx) / (len(salary) - 2)
