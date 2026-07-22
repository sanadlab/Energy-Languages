class Solution:
    def minSwaps(self, s: str) -> int:
        balance = 0
        min_balance = 0
        
        for ch in s:
            if ch == '[':
                balance += 1
            else:
                balance -= 1
            min_balance = min(min_balance, balance)
        
        return (-min_balance + 1) // 2
