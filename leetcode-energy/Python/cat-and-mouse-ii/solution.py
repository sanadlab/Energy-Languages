from typing import List
from heapq import heappush, heappop


class Solution:
    def canMouseWin(self, grid: List[str], catJump: int, mouseJump: int) -> bool:
        rows, cols = len(grid), len(grid[0])
        pos_id = [[-1] * cols for _ in range(rows)]
        positions = []
        mouse_start = cat_start = food = -1

        for r in range(rows):
            for c in range(cols):
                if grid[r][c] != '#':
                    idx = len(positions)
                    pos_id[r][c] = idx
                    positions.append((r, c))
                    if grid[r][c] == 'M':
                        mouse_start = idx
                    elif grid[r][c] == 'C':
                        cat_start = idx
                    elif grid[r][c] == 'F':
                        food = idx

        n = len(positions)
        dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]

        def build_moves(jump: int):
            moves = [[] for _ in range(n)]
            rev = [[] for _ in range(n)]

            for i, (r, c) in enumerate(positions):
                arr = [i]
                for dr, dc in dirs:
                    for step in range(1, jump + 1):
                        nr, nc = r + dr * step, c + dc * step
                        if nr < 0 or nr >= rows or nc < 0 or nc >= cols or pos_id[nr][nc] == -1:
                            break
                        arr.append(pos_id[nr][nc])
                moves[i] = arr

            for i in range(n):
                for j in moves[i]:
                    rev[j].append(i)

            return moves, rev

        mouse_moves, mouse_rev = build_moves(mouseJump)
        cat_moves, cat_rev = build_moves(catJump)

        UNKNOWN, MOUSE_WIN, CAT_WIN = 0, 1, 2
        MOUSE_TURN, CAT_TURN = 0, 1

        total = n * n * 2
        color = [UNKNOWN] * total
        degree = [0] * total
        dist = [-1] * total
        max_child_dist = [0] * total

        def state_id(m: int, c: int, turn: int) -> int:
            return ((m * n + c) << 1) | turn

        for m in range(n):
            for c in range(n):
                base = (m * n + c) << 1
                degree[base | MOUSE_TURN] = len(mouse_moves[m])
                degree[base | CAT_TURN] = len(cat_moves[c])

        heap = []

        for m in range(n):
            for c in range(n):
                outcome = UNKNOWN
                if m == food:
                    outcome = MOUSE_WIN
                elif c == food or m == c:
                    outcome = CAT_WIN

                if outcome != UNKNOWN:
                    for turn in (MOUSE_TURN, CAT_TURN):
                        s = state_id(m, c, turn)
                        color[s] = outcome
                        dist[s] = 0
                        heappush(heap, (0, s))

        def set_color(s: int, outcome: int, d: int):
            color[s] = outcome
            dist[s] = d
            heappush(heap, (d, s))

        while heap:
            d, s = heappop(heap)
            if dist[s] != d:
                continue

            outcome = color[s]
            turn = s & 1
            x = s >> 1
            m, c = divmod(x, n)

            parents = []
            if turn == MOUSE_TURN:
                for pc in cat_rev[c]:
                    parents.append(state_id(m, pc, CAT_TURN))
            else:
                for pm in mouse_rev[m]:
                    parents.append(state_id(pm, c, MOUSE_TURN))

            for ps in parents:
                if color[ps] != UNKNOWN:
                    continue

                pturn = ps & 1

                if (pturn == MOUSE_TURN and outcome == MOUSE_WIN) or (
                    pturn == CAT_TURN and outcome == CAT_WIN
                ):
                    set_color(ps, outcome, d + 1)
                else:
                    degree[ps] -= 1
                    if d > max_child_dist[ps]:
                        max_child_dist[ps] = d

                    if degree[ps] == 0:
                        losing_outcome = CAT_WIN if pturn == MOUSE_TURN else MOUSE_WIN
                        set_color(ps, losing_outcome, max_child_dist[ps] + 1)

        initial = state_id(mouse_start, cat_start, MOUSE_TURN)
        return color[initial] == MOUSE_WIN and dist[initial] <= 1000
