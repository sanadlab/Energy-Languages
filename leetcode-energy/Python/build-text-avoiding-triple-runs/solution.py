class Solution:
    def strWithout3a3b(self, a: int, b: int) -> str:
        res = []
        # Use a greedy approach: always append the character with more remaining count,
        # but avoid adding three consecutive identical letters.
        while a > 0 or b > 0:
            # Check if we can add 'a'
            if (a > b and (len(res) < 2 or res[-1] != 'a' or res[-2] != 'a')) or (b > 0 and (len(res) >= 2 and res[-1] == 'b' and res[-2] == 'b')):
                res.append('a')
                a -= 1
            # Otherwise add 'b'
            else:
                res.append('b')
                b -= 1
        return "".join(res)
