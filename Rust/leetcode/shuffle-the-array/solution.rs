impl Solution {
    pub fn shuffle(nums: Vec<i32>, n: i32) -> Vec<i32> {
        let m = nums.len() / 2;
        let mut res = Vec::with_capacity(2 * m);
        for i in 0..m {
            res.push(nums[i]);
            res.push(nums[i + m]);
        }
        res
    }
}
