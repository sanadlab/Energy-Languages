impl Solution {
    pub fn is_match(s: String, p: String) -> bool {
        let sb = s.as_bytes();
        let pb = p.as_bytes();
        let m = sb.len();
        let n = pb.len();
        let mut dp = vec![vec![false; n + 1]; m + 1];
        dp[m][n] = true;
        for i in (0..=m).rev() {
            for j in (0..n).rev() {
                let first = i < m && (pb[j] == sb[i] || pb[j] == b'.');
                if j + 1 < n && pb[j + 1] == b'*' {
                    dp[i][j] = dp[i][j + 2] || (first && dp[i + 1][j]);
                } else {
                    dp[i][j] = first && dp[i + 1][j + 1];
                }
            }
        }
        dp[0][0]
    }
}
