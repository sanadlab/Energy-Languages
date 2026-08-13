class Solution:
    def strWithout3a3b(self, a, b):
        res = []
        while a > 0 or b > 0:
            n = len(res)
            if n >= 2 and res[-1] == res[-2]:
                write_a = res[-1] == 'b'
            else:
                write_a = a >= b
            if write_a:
                if a == 0:
                    break
                res.append('a'); a -= 1
            else:
                if b == 0:
                    break
                res.append('b'); b -= 1
        return ''.join(res)
