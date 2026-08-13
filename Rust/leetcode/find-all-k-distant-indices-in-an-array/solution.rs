impl Solution {
    pub fn find_k_distant_indices(nums: Vec<i32>, key: i32, k: i32) -> Vec<i32> {
        let n = nums.len();
        let mut is_k_distant = vec![false; n];
        
        for j in 0..n {
            if nums[j] == key {
                let start = (j as i32 - k).max(0) as usize;
                let end = ((j as i32 + k) as usize).min(n - 1);

                for i in start..=end {
                    is_k_distant[i] = true;
                }
            }
        }
        
        let mut result = Vec::new();
        for i in 0..n {
            if is_k_distant[i] {
                result.push(i as i32);
            }
        }
        
        result
    }
}