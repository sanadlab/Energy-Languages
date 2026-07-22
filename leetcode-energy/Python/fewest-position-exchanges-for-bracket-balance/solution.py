class Solution:
    def minSwaps(self, s: str) -> int:
        # The idea:
        # We keep track of the balance of brackets as we scan the string.
        # balance = number of '[' minus number of ']'
        # When balance goes negative, it means we have more ']' than '[' so far,
        # which is invalid and needs fixing by swapping.
        # Each time balance goes negative, we need one swap to fix it.
        # The minimal number of swaps is the number of times balance goes negative.
        
        balance = 0
        swaps = 0
        for ch in s:
            if ch == '[':
                balance += 1
            else:
                balance -= 1
            # If balance is negative, we have an unmatched ']'
            if balance < 0:
                swaps += 1
                balance = 1  # After swap, we consider balance fixed by adding one '['
        return swaps
