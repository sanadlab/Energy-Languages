impl Solution {
    pub fn largest_magic_square(grid: Vec<Vec<i32>>) -> i32 {
        let m = grid.len();
        let n = grid[0].len();

        // Prefix sums for rows and columns
        let mut row_prefix = vec![vec![0; n + 1]; m];
        let mut col_prefix = vec![vec![0; n]; m + 1];

        for i in 0..m {
            for j in 0..n {
                row_prefix[i][j + 1] = row_prefix[i][j] + grid[i][j];
                col_prefix[i + 1][j] = col_prefix[i][j] + grid[i][j];
            }
        }

        // Check if a k x k square starting at (r, c) is magic
        // Using prefix sums to quickly get row sums and column sums
        fn is_magic(
            r: usize,
            c: usize,
            k: usize,
            grid: &Vec<Vec<i32>>,
            row_prefix: &Vec<Vec<i32>>,
            col_prefix: &Vec<Vec<i32>>,
        ) -> bool {
            // sum of first row
            let target = row_prefix[r][c + k] - row_prefix[r][c];

            // check all rows
            for i in r..r + k {
                let row_sum = row_prefix[i][c + k] - row_prefix[i][c];
                if row_sum != target {
                    return false;
                }
            }

            // check all columns
            for j in c..c + k {
                let col_sum = col_prefix[r + k][j] - col_prefix[r][j];
                if col_sum != target {
                    return false;
                }
            }

            // check main diagonal
            let mut diag1 = 0;
            for i in 0..k {
                diag1 += grid[r + i][c + i];
            }
            if diag1 != target {
                return false;
            }

            // check anti diagonal
            let mut diag2 = 0;
            for i in 0..k {
                diag2 += grid[r + i][c + k - 1 - i];
            }
            if diag2 != target {
                return false;
            }

            true
        }

        let max_side = m.min(n);

        for size in (1..=max_side).rev() {
            for r in 0..=m - size {
                for c in 0..=n - size {
                    if is_magic(r, c, size, &grid, &row_prefix, &col_prefix) {
                        return size as i32;
                    }
                }
            }
        }

        1
    }
}