class Solution:
    def ambiguousCoordinates(self, s: str) -> list[str]:
        # Remove the parentheses
        s = s[1:-1]

        def valid_nums(s: str) -> list[str]:
            # Generate all valid numbers from s by inserting decimal point or not
            n = len(s)
            res = []
            # If s is a single digit, always valid
            if n == 1:
                return [s]

            # If s starts and ends with '0', only "0" is valid, but length > 1 means invalid
            if s[0] == '0' and s[-1] == '0':
                return []

            # If s starts with '0', only valid decimal numbers like "0.xxx"
            if s[0] == '0':
                # Only one decimal point after first zero
                res.append(s[0] + '.' + s[1:])
                return res

            # If s ends with '0', no decimal point allowed, only integer
            if s[-1] == '0':
                res.append(s)
                return res

            # Otherwise, s itself is valid integer
            res.append(s)
            # Also try all possible decimal points
            for i in range(1, n):
                res.append(s[:i] + '.' + s[i:])
            return res

        n = len(s)
        ans = []
        for i in range(1, n):
            lefts = valid_nums(s[:i])
            rights = valid_nums(s[i:])
            for l in lefts:
                for r in rights:
                    ans.append(f"({l}, {r})")
        return ans
