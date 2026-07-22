class Solution:
    def hitBricks(self, grid: list[list[int]], hits: list[list[int]]) -> list[int]:
        m, n = len(grid), len(grid[0])
        
        # Directions for neighbors
        directions = [(1,0), (-1,0), (0,1), (0,-1)]
        
        # Convert 2D position to 1D index for Union-Find
        def index(r, c):
            return r * n + c
        
        # Union-Find data structure with size tracking
        parent = list(range(m * n + 1))
        size = [1] * (m * n + 1)
        
        # Find with path compression
        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x
        
        # Union by size
        def union(x, y):
            rx, ry = find(x), find(y)
            if rx != ry:
                if size[rx] < size[ry]:
                    rx, ry = ry, rx
                parent[ry] = rx
                size[rx] += size[ry]
        
        # Connect stable bricks to the top virtual node (m*n)
        top = m * n
        
        # Copy grid and apply all hits first (remove bricks)
        grid2 = [row[:] for row in grid]
        for r, c in hits:
            if grid2[r][c] == 1:
                grid2[r][c] = 0
        
        # Build union-find on grid2
        for r in range(m):
            for c in range(n):
                if grid2[r][c] == 1:
                    # If on top row, union with top
                    if r == 0:
                        union(index(r,c), top)
                    # Union with neighbors if they are bricks
                    for dr, dc in directions:
                        nr, nc = r + dr, c + dc
                        if 0 <= nr < m and 0 <= nc < n and grid2[nr][nc] == 1:
                            union(index(r,c), index(nr,nc))
        
        res = []
        # Process hits in reverse order
        for r, c in reversed(hits):
            # If no brick originally, no bricks fall
            if grid[r][c] == 0:
                res.append(0)
                continue
            
            # Before adding back the brick, record the size of the top component
            prev_top_size = size[find(top)]
            
            # Add back the brick
            grid2[r][c] = 1
            
            # If on top row, union with top
            if r == 0:
                union(index(r,c), top)
            
            # Union with neighbors if they are bricks
            for dr, dc in directions:
                nr, nc = r + dr, c + dc
                if 0 <= nr < m and 0 <= nc < n and grid2[nr][nc] == 1:
                    union(index(r,c), index(nr,nc))
            
            # After union, get new top size
            new_top_size = size[find(top)]
            
            # Number of bricks that became stable due to this addition (excluding the brick itself)
            fallen = max(0, new_top_size - prev_top_size - 1)
            res.append(fallen)
        
        # Reverse result to match original hits order
        return res[::-1]
