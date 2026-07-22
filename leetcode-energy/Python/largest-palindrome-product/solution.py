class Solution:
    def largestPalindrome(self, n: int) -> int:
        if n == 1:
            return 9

        mod = 1337
        hi = 10 ** n - 1
        lo = 10 ** (n - 1)
        start = hi - (hi % 11)

        for left in range(hi, lo - 1, -1):
            s = str(left)
            pal = int(s + s[::-1])

            min_factor = (pal + hi - 1) // hi
            if min_factor < lo:
                min_factor = lo

            factor = start
            while factor >= min_factor:
                if pal % factor == 0:
                    return pal % mod
                factor -= 11

        return 0
