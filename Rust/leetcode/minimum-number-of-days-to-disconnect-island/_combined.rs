pub struct Solution;

impl Solution {
    pub fn min_days(mut grid: Vec<Vec<i32>>) -> i32 {
        let rows = grid.len();
        let cols = grid[0].len();
        if Self::count_islands(&grid, rows, cols) != 1 {
            return 0;
        }
        for i in 0..rows {
            for j in 0..cols {
                if grid[i][j] == 1 {
                    grid[i][j] = 0;
                    if Self::count_islands(&grid, rows, cols) != 1 {
                        grid[i][j] = 1;
                        return 1;
                    }
                    grid[i][j] = 1;
                }
            }
        }
        2
    }
    fn count_islands(grid: &Vec<Vec<i32>>, rows: usize, cols: usize) -> i32 {
        let mut visited = vec![vec![false; cols]; rows];
        let mut count = 0;
        for i in 0..rows {
            for j in 0..cols {
                if grid[i][j] == 1 && !visited[i][j] {
                    count += 1;
                    let mut stack = vec![(i, j)];
                    visited[i][j] = true;
                    while let Some((x, y)) = stack.pop() {
                        let dirs: [(i32, i32); 4] = [(1, 0), (-1, 0), (0, 1), (0, -1)];
                        for (dx, dy) in dirs.iter() {
                            let nx = x as i32 + dx;
                            let ny = y as i32 + dy;
                            if nx >= 0 && nx < rows as i32 && ny >= 0 && ny < cols as i32 {
                                let (nx, ny) = (nx as usize, ny as usize);
                                if grid[nx][ny] == 1 && !visited[nx][ny] {
                                    visited[nx][ny] = true;
                                    stack.push((nx, ny));
                                }
                            }
                        }
                    }
                }
            }
        }
        count
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::min_days(vec![vec![1,2],vec![3,4]]);
}
