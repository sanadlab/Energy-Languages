impl Solution {
    pub fn num_of_ways(nums: Vec<i32>) -> i32 {
        const MOD: i64 = 1_000_000_007;
        let n = nums.len();
        let mut c = vec![vec![0i64; n + 1]; n + 1];
        for i in 0..=n {
            c[i][0] = 1;
            for j in 1..=i {
                c[i][j] = (c[i - 1][j - 1] + c[i - 1][j]) % MOD;
            }
        }
        fn ways(arr: &[i32], c: &Vec<Vec<i64>>) -> i64 {
            const MOD: i64 = 1_000_000_007;
            let m = arr.len();
            if m <= 2 {
                return 1;
            }
            let root = arr[0];
            let mut left = Vec::new();
            let mut right = Vec::new();
            for i in 1..m {
                if arr[i] < root {
                    left.push(arr[i]);
                } else {
                    right.push(arr[i]);
                }
            }
            c[m - 1][left.len()] * ways(&left, c) % MOD * ways(&right, c) % MOD
        }
        ((ways(&nums, &c) - 1 + MOD) % MOD) as i32
    }
}
