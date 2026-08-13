struct Solution;

impl Solution {
    pub fn is_match(s: String, p: String) -> bool {
        let n = s.len();
        let m = p.len();

        let s_chars: Vec<char> = s.chars().collect();
        let p_chars: Vec<char> = p.chars().collect();

        let mut dp = vec![vec![false; m + 1]; n + 1];

        dp[0][0] = true;

        for j in 1..=m {
            if p_chars[j - 1] == '*' {
                dp[0][j] = dp[0][j - 1];
            } else {
                dp[0][j] = false;
            }
        }

        for i in 1..=n {
            for j in 1..=m {
                if p_chars[j - 1] == '*' {
                    dp[i][j] = dp[i][j - 1] || dp[i - 1][j];
                } else if p_chars[j - 1] == '?' || s_chars[i - 1] == p_chars[j - 1] {
                    dp[i][j] = dp[i - 1][j - 1];
                } else {
                    dp[i][j] = false;
                }
            }
        }

        dp[n][m]
    }
}