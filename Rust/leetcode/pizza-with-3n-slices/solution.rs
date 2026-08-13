impl Solution {
    pub fn max_size_slices(slices: Vec<i32>) -> i32 {
        let total = slices.len();
        let k = total / 3;
        if k == 0 {
            return 0;
        }
        let a = slices[..total - 1].to_vec();
        let b = slices[1..].to_vec();
        pizza_best(&a, k).max(pizza_best(&b, k))
    }
}

fn pizza_best(nums: &[i32], k: usize) -> i32 {
    let n = nums.len();
    let neg: i64 = i64::MIN / 4;
    let mut dp = vec![vec![neg; k + 1]; n + 1];
    for i in 0..=n {
        dp[i][0] = 0;
    }
    for i in 1..=n {
        for j in 1..=k {
            let skip = dp[i - 1][j];
            let prev = if i >= 2 {
                dp[i - 2][j - 1]
            } else if j == 1 {
                0
            } else {
                neg
            };
            let take = prev + nums[i - 1] as i64;
            dp[i][j] = skip.max(take);
        }
    }
    dp[n][k] as i32
}
