import sys
sys.set_int_max_str_digits(1000000)


class Solution:
    def abbreviateProduct(self, left: int, right: int) -> str:
        p = 1
        for i in range(left, right + 1):
            p *= i
        c = 0
        while p % 10 == 0:
            p //= 10
            c += 1
        s = str(p)
        if len(s) <= 10:
            return f"{s}e{c}"
        return f"{s[:5]}...{s[-5:]}e{c}"
