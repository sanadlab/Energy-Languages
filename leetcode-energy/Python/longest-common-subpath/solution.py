from typing import List


class Solution:
    def longestCommonSubpath(self, n: int, paths: List[List[int]]) -> int:
        base_idx = min(range(len(paths)), key=lambda i: len(paths[i]))
        base = paths[base_idx]

        trans = [{}]
        link = [-1]
        length = [0]
        last = 0

        for c in base:
            cur = len(length)
            length.append(length[last] + 1)
            link.append(0)
            trans.append({})

            p = last
            while p != -1 and c not in trans[p]:
                trans[p][c] = cur
                p = link[p]

            if p == -1:
                link[cur] = 0
            else:
                q = trans[p][c]
                if length[p] + 1 == length[q]:
                    link[cur] = q
                else:
                    clone = len(length)
                    length.append(length[p] + 1)
                    link.append(link[q])
                    trans.append(trans[q].copy())

                    while p != -1 and trans[p].get(c) == q:
                        trans[p][c] = clone
                        p = link[p]

                    link[q] = clone
                    link[cur] = clone

            last = cur

        size = len(length)
        order = list(range(1, size))
        order.sort(key=lambda x: length[x], reverse=True)

        common = length[:]

        for i, path in enumerate(paths):
            if i == base_idx:
                continue

            mx = [0] * size
            v = 0
            l = 0

            for c in path:
                if c in trans[v]:
                    v = trans[v][c]
                    l += 1
                else:
                    while v != -1 and c not in trans[v]:
                        v = link[v]

                    if v == -1:
                        v = 0
                        l = 0
                        continue

                    l = length[v] + 1
                    v = trans[v][c]

                if l > mx[v]:
                    mx[v] = l

            for state in order:
                p = link[state]
                val = mx[state]
                if val:
                    if val > length[p]:
                        val = length[p]
                    if val > mx[p]:
                        mx[p] = val

            for state in range(1, size):
                if mx[state] < common[state]:
                    common[state] = mx[state]

        return max(common)
