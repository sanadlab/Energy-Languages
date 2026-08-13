pub struct Solution;

impl Solution {
    pub fn next_greater_elements(nums: Vec<i32>) -> Vec<i32> {
        let n = nums.len();
        let mut res = vec![-1; n];
        let mut st: Vec<usize> = Vec::new();
        for i in 0..2 * n {
            let cur = nums[i % n];
            while let Some(&top) = st.last() {
                if nums[top] < cur {
                    res[top] = cur;
                    st.pop();
                } else {
                    break;
                }
            }
            if i < n {
                st.push(i);
            }
        }
        res
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::next_greater_elements(vec![1,2,3,4,5]);
}
