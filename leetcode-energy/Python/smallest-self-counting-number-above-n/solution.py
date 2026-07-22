class Solution:
    def nextBeautifulNumber(self, n: int) -> int:
        # Precompute all numerically balanced numbers up to a certain limit.
        # Since n <= 10^6, and the next balanced number can be a bit larger,
        # we can generate all balanced numbers up to 10^7 or so.
        
        # A numerically balanced number means:
        # For each digit d in the number, the count of d equals d.
        # Digits 0 cannot appear because 0 times means no zero digit.
        
        # We generate all possible balanced numbers by trying all digit counts from 1 to 7 digits.
        # For each digit from 1 to 9, we can have count = digit or 0.
        # We try all combinations of digits and counts that sum to length <= 7.
        
        from itertools import permutations
        
        balanced_numbers = set()
        
        # We try all combinations of digits 1-9 with counts equal to digit
        # The total length is sum of counts.
        # We generate all subsets of digits 1-9, and for each subset, form the number by repeating digit d, d times.
        # Then permute the digits to get all possible numbers.
        # Add all unique numbers to balanced_numbers.
        
        digits = [str(d) for d in range(1,10)]
        
        # We try all subsets of digits from 1 to 9 digits
        # For each subset, the length is sum of digits in subset
        # If length <= 7, generate all permutations of the digits repeated d times.
        
        from math import factorial
        
        def backtrack(start, chosen, length):
            # chosen: list of digits chosen
            # length: total length so far
            if length > 7:
                return
            if length > 0:
                # generate the number from chosen digits
                # chosen is list of digits, each repeated digit times
                # For example, chosen = ['1','3'] means 1 repeated 1 time, 3 repeated 3 times
                # So the number digits are: '1' * 1 + '3' * 3 = ['1','3','3','3']
                digits_list = []
                for d in chosen:
                    digits_list.extend([d]*int(d))
                # generate all unique permutations
                # to avoid duplicates, use set
                from itertools import permutations
                perms = set(permutations(digits_list))
                for p in perms:
                    if p[0] == '0':
                        continue
                    num = int(''.join(p))
                    balanced_numbers.add(num)
            for i in range(start, 9):
                d = digits[i]
                backtrack(i+1, chosen + [d], length + int(d))
        
        backtrack(0, [], 0)
        
        # Now find the smallest balanced number > n
        candidates = [x for x in balanced_numbers if x > n]
        return min(candidates)
