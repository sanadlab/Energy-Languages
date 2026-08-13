impl Solution {
    pub fn count_max_or_subsets(nums: Vec<i32>) -> i32 {
        let n = nums.len();
        let mut max_or = 0;
        for &num in &nums {
            max_or |= num;
        }
        
        let mut count = 0;
        // There are at most 2^n subsets, n <= 16 so this is feasible
        for mask in 1..(1 << n) {
            let mut or_val = 0;
            for i in 0..n {
                if (mask & (1 << i)) != 0 {
                    or_val |= nums[i];
                }
            }
            if or_val == max_or {
                count += 1;
            }
        }
        
        count
    }
}