use std::collections::HashMap;

impl Solution {
    fn helper(a: &Vec<i32>, b: &Vec<i32>) -> i64 {
        let mut cnt: i64 = 0;
        for &x in a.iter() {
            let t = x as i64 * x as i64;
            let mut seen: HashMap<i64, i64> = HashMap::new();
            for &y in b.iter() {
                let yy = y as i64;
                if t % yy == 0 {
                    let need = t / yy;
                    if let Some(c) = seen.get(&need) {
                        cnt += c;
                    }
                }
                *seen.entry(yy).or_insert(0) += 1;
            }
        }
        cnt
    }
    pub fn num_triplets(nums1: Vec<i32>, nums2: Vec<i32>) -> i32 {
        (Solution::helper(&nums1, &nums2) + Solution::helper(&nums2, &nums1)) as i32
    }
}
