class Solution:
    def spiralMatrixIII(self, rows: int, cols: int, rStart: int, cStart: int) -> list[list[int]]:
        # Directions: east, south, west, north
        directions = [(0,1), (1,0), (0,-1), (-1,0)]
        result = []
        result.append([rStart, cStart])
        if rows * cols == 1:
            return result
        
        step = 1
        r, c = rStart, cStart
        while len(result) < rows * cols:
            for i in range(4):
                dr, dc = directions[i]
                # For east and south, move step times
                # For west and north, move step times
                # After every two directions, step increases by 1
                move_len = step
                for _ in range(move_len):
                    r += dr
                    c += dc
                    if 0 <= r < rows and 0 <= c < cols:
                        result.append([r, c])
                        if len(result) == rows * cols:
                            return result
                if i % 2 == 1:
                    step += 1
        return result
