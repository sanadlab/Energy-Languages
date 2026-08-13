impl Solution {
    pub fn max_sum_two_no_overlap(nums: Vec<i32>, first_len: i32, second_len: i32) -> i32 {
        let n = nums.len();
        let mut pre = vec![0i32; n + 1];
        for i in 0..n {
            pre[i + 1] = pre[i] + nums[i];
        }
        let best = |l: usize, m: usize| -> i32 {
            let mut res = 0;
            let mut max_l = 0;
            if l + m <= n {
                for i in (l + m)..=n {
                    max_l = max_l.max(pre[i - m] - pre[i - m - l]);
                    res = res.max(max_l + pre[i] - pre[i - m]);
                }
            }
            res
        };
        let fl = first_len as usize;
        let sl = second_len as usize;
        best(fl, sl).max(best(sl, fl))
    }
}
