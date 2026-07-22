from typing import List
from itertools import product

class Solution:
    def countCombinations(self, pieces: List[str], positions: List[List[int]]) -> int:
        dir_map = {
            "rook": [(1, 0), (-1, 0), (0, 1), (0, -1)],
            "bishop": [(1, 1), (1, -1), (-1, 1), (-1, -1)],
            "queen": [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (1, -1), (-1, 1), (-1, -1)]
        }

        all_moves = []

        for piece, (r, c) in zip(pieces, positions):
            piece = piece.strip()
            moves = [(0, 0, 0)]

            for dr, dc in dir_map[piece]:
                nr, nc = r + dr, c + dc
                dist = 1

                while 1 <= nr <= 8 and 1 <= nc <= 8:
                    moves.append((dr, dc, dist))
                    nr += dr
                    nc += dc
                    dist += 1

            all_moves.append(moves)

        ans = 0
        n = len(pieces)

        for combination in product(*all_moves):
            valid = True

            for t in range(8):
                seen = set()

                for i in range(n):
                    r, c = positions[i]
                    dr, dc, dist = combination[i]
                    step = min(t, dist)
                    pos = (r + dr * step, c + dc * step)

                    if pos in seen:
                        valid = False
                        break

                    seen.add(pos)

                if not valid:
                    break

            if valid:
                ans += 1

        return ans
