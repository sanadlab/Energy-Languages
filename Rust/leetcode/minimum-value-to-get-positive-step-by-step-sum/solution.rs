impl Solution {
    pub fn min_start_value(nums: Vec<i32>) -> i32 {
        let mut prefix = 0;
        let mut min_prefix = 0;
        for x in nums {
            prefix += x;
            if prefix < min_prefix {
                min_prefix = prefix;
            }
        }
        std::cmp::max(1, 1 - min_prefix)
    }
}
