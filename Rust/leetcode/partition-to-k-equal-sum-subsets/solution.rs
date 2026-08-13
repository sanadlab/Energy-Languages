impl Solution {
    fn backtrack(nums: &Vec<i32>, used: &mut Vec<bool>, k: i32, cur: i64, start: usize, target: i64) -> bool {
        if k == 0 {
            return true;
        }
        if cur == target {
            return Solution::backtrack(nums, used, k - 1, 0, 0, target);
        }
        for i in start..nums.len() {
            if used[i] || cur + nums[i] as i64 > target {
                continue;
            }
            used[i] = true;
            if Solution::backtrack(nums, used, k, cur + nums[i] as i64, i + 1, target) {
                return true;
            }
            used[i] = false;
            if cur == 0 {
                break;
            }
        }
        false
    }
    pub fn can_partition_k_subsets(nums: Vec<i32>, k: i32) -> bool {
        if k <= 0 || (nums.len() as i32) < k {
            return false;
        }
        let sum: i64 = nums.iter().map(|&x| x as i64).sum();
        if sum % (k as i64) != 0 {
            return false;
        }
        let target = sum / (k as i64);
        let mut nums = nums;
        nums.sort_unstable_by(|a, b| b.cmp(a));
        if nums[0] as i64 > target {
            return false;
        }
        let mut used = vec![false; nums.len()];
        Solution::backtrack(&nums, &mut used, k, 0, 0, target)
    }
}
