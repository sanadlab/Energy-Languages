impl Solution {
    pub fn regions_by_slashes(grid: Vec<String>) -> i32 {
        let n = grid.len();
        let mut parent: Vec<usize> = (0..4 * n * n).collect();
        fn find(parent: &mut Vec<usize>, mut x: usize) -> usize {
            while parent[x] != x {
                parent[x] = parent[parent[x]];
                x = parent[x];
            }
            x
        }
        fn union(parent: &mut Vec<usize>, a: usize, b: usize) {
            let ra = find(parent, a);
            let rb = find(parent, b);
            if ra != rb {
                parent[ra] = rb;
            }
        }
        for r in 0..n {
            let bytes = grid[r].as_bytes();
            for c in 0..n {
                let base = 4 * (r * n + c);
                let (top, right, bottom, left) = (base, base + 1, base + 2, base + 3);
                let ch = if c < bytes.len() { bytes[c] as char } else { ' ' };
                if ch == '/' {
                    union(&mut parent, top, left);
                    union(&mut parent, right, bottom);
                } else if ch == '\\' {
                    union(&mut parent, top, right);
                    union(&mut parent, left, bottom);
                } else {
                    union(&mut parent, top, right);
                    union(&mut parent, right, bottom);
                    union(&mut parent, bottom, left);
                }
                if c + 1 < n {
                    union(&mut parent, right, 4 * (r * n + c + 1) + 3);
                }
                if r + 1 < n {
                    union(&mut parent, bottom, 4 * ((r + 1) * n + c));
                }
            }
        }
        let mut cnt = 0i32;
        for i in 0..4 * n * n {
            if find(&mut parent, i) == i {
                cnt += 1;
            }
        }
        cnt
    }
}
