import sys

try:
    sys.set_int_max_str_digits(0)
except Exception:
    pass


class Solution:
    def abbreviateProduct(self, left: int, right: int) -> str:
        product = 1

        for x in range(left, right + 1):
            product *= x

        zeros = 0
        while product % 10 == 0:
            product //= 10
            zeros += 1

        s = str(product)

        if len(s) > 10:
            return f"{s[:5]}...{s[-5:]}e{zeros}"
        return f"{s}e{zeros}"
