from collections import defaultdict

class Solution:
    def maxEqualFreq(self, nums: list[int]) -> int:
        count = defaultdict(int)  # count of each number
        freq = defaultdict(int)   # how many numbers have a certain count
        max_len = 0
        max_freq = 0
        
        for i, num in enumerate(nums):
            if count[num] > 0:
                freq[count[num]] -= 1
                if freq[count[num]] == 0:
                    del freq[count[num]]
            count[num] += 1
            freq[count[num]] += 1
            max_freq = max(max_freq, count[num])
            
            # Conditions to check if prefix [0..i] can be made uniform by removing one element:
            # 1) All numbers appear once: freq keys = {1}, or only one number with freq 1
            # 2) All numbers have the same freq except one number which has freq 1 (can remove that one)
            # 3) All numbers have the same freq except one number which has freq max_freq and count 1 (can remove one from that number)
            # 4) Only one number present (freq keys = {max_freq}) and max_freq = 1 (remove one element to get empty)
            
            # Number of distinct frequencies
            if len(freq) == 1:
                # Only one frequency
                (f, c) = next(iter(freq.items()))
                # Either frequency is 1 (all numbers appear once) or only one number with freq f
                if f == 1 or c == 1:
                    max_len = i + 1
            elif len(freq) == 2:
                (f1, c1), (f2, c2) = sorted(freq.items())
                # Case 1: one freq is 1 and only one number has it, e.g. freq = {1:1, x:c2}
                if f1 == 1 and c1 == 1:
                    max_len = i + 1
                # Case 2: frequencies differ by 1 and the higher freq has only one number
                elif f2 == f1 + 1 and c2 == 1:
                    max_len = i + 1
        
        return max_len
