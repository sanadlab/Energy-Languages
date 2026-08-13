impl Solution {
    pub fn max_compatibility_sum(students: Vec<Vec<i32>>, mentors: Vec<Vec<i32>>) -> i32 {
        let m = students.len();
        let n = if m > 0 { students[0].len() } else { 0 };
        let mut score = vec![vec![0i32; m]; m];
        for i in 0..m {
            for j in 0..m {
                for k in 0..n {
                    if students[i][k] == mentors[j][k] { score[i][j] += 1; }
                }
            }
        }
        let mut dp = vec![0i32; 1 << m];
        for mask in 0..(1usize << m) {
            let i = (mask as u32).count_ones() as usize;
            if i >= m { continue; }
            for j in 0..m {
                if (mask >> j) & 1 == 1 { continue; }
                let nm = mask | (1 << j);
                let val = dp[mask] + score[i][j];
                if val > dp[nm] { dp[nm] = val; }
            }
        }
        dp[(1 << m) - 1]
    }
}
