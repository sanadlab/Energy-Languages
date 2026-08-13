from typing import List


class Solution:
    def removeInvalidParentheses(self, s: str) -> List[str]:
        def valid(st):
            cnt = 0
            for ch in st:
                if ch == '(':
                    cnt += 1
                elif ch == ')':
                    cnt -= 1
                    if cnt < 0:
                        return False
            return cnt == 0

        level = {s}
        while level:
            valids = [st for st in level if valid(st)]
            if valids:
                return valids
            nxt = set()
            for st in level:
                for i in range(len(st)):
                    if st[i] == '(' or st[i] == ')':
                        nxt.add(st[:i] + st[i + 1:])
            level = nxt
        return [""]
