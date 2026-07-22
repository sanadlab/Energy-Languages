class Solution:
    def maximumBinaryString(self, binary: str) -> str:
        # Count the number of zeros in the string
        zero_count = binary.count('0')
        if zero_count == 0:
            # No zeros, already maximum
            return binary
        
        # Find the index of the first zero
        first_zero = binary.index('0')
        
        # The maximum string will have:
        # - all ones before first_zero (unchanged)
        # - one zero at position first_zero + zero_count - 1
        # - all other positions ones
        # Explanation:
        # After operations, all zeros can be "moved" to a single zero at position first_zero + zero_count - 1,
        # and all other zeros turned into ones.
        
        n = len(binary)
        res = ['1'] * n
        # place zero at the position first_zero + zero_count - 1
        zero_pos = first_zero + zero_count - 1
        res[zero_pos] = '0'
        
        return ''.join(res)
