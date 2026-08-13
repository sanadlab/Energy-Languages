impl Solution {
    pub fn hit_bricks(grid: Vec<Vec<i32>>, hits: Vec<Vec<i32>>) -> Vec<i32> {
        fn find(parent: &mut Vec<usize>, mut x: usize) -> usize {
            while parent[x] != x {
                parent[x] = parent[parent[x]];
                x = parent[x];
            }
            x
        }
        fn union(parent: &mut Vec<usize>, sz: &mut Vec<usize>, a: usize, b: usize) {
            let ra = find(parent, a);
            let rb = find(parent, b);
            if ra == rb {
                return;
            }
            if sz[ra] < sz[rb] {
                parent[ra] = rb;
                sz[rb] += sz[ra];
            } else {
                parent[rb] = ra;
                sz[ra] += sz[rb];
            }
        }

        let m = grid.len();
        let n = if m > 0 { grid[0].len() } else { 0 };
        let total = m * n;
        let top = total;
        let mut parent: Vec<usize> = (0..=total).collect();
        let mut sz: Vec<usize> = vec![1; total + 1];

        let in_b = |r: i64, c: i64| -> bool {
            r >= 0 && (r as usize) < m && c >= 0 && (c as usize) < n
        };

        let mut g = vec![vec![0i32; n]; m];
        for r in 0..m {
            let cols = grid[r].len().min(n);
            for c in 0..cols {
                if grid[r][c] == 1 {
                    g[r][c] = 1;
                }
            }
        }

        for h in &hits {
            if h.len() < 2 {
                continue;
            }
            let (r, c) = (h[0] as i64, h[1] as i64);
            if in_b(r, c) {
                g[r as usize][c as usize] = 0;
            }
        }

        for r in 0..m {
            for c in 0..n {
                if g[r][c] == 1 {
                    let cur = r * n + c;
                    if r == 0 {
                        union(&mut parent, &mut sz, cur, top);
                    }
                    if r > 0 && g[r - 1][c] == 1 {
                        union(&mut parent, &mut sz, cur, (r - 1) * n + c);
                    }
                    if c > 0 && g[r][c - 1] == 1 {
                        union(&mut parent, &mut sz, cur, r * n + c - 1);
                    }
                }
            }
        }

        let dirs: [(i64, i64); 4] = [(1, 0), (-1, 0), (0, 1), (0, -1)];
        let mut res = vec![0i32; hits.len()];
        for i in (0..hits.len()).rev() {
            if hits[i].len() < 2 {
                continue;
            }
            let (ri, ci) = (hits[i][0] as i64, hits[i][1] as i64);
            if !in_b(ri, ci) {
                continue;
            }
            let (r, c) = (ri as usize, ci as usize);
            if grid[r][c] != 1 {
                continue;
            }
            let root = find(&mut parent, top);
            let before = sz[root];
            g[r][c] = 1;
            let cur = r * n + c;
            if r == 0 {
                union(&mut parent, &mut sz, cur, top);
            }
            for &(dr, dc) in &dirs {
                let nr = ri + dr;
                let nc = ci + dc;
                if in_b(nr, nc) && g[nr as usize][nc as usize] == 1 {
                    union(&mut parent, &mut sz, cur, (nr as usize) * n + (nc as usize));
                }
            }
            let root2 = find(&mut parent, top);
            let after = sz[root2];
            res[i] = if after > before + 1 {
                (after - before - 1) as i32
            } else {
                0
            };
        }
        res
    }
}
