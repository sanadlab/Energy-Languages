use std::collections::HashMap;
use std::collections::HashSet;

impl Solution {
    pub fn can_cross(stones: Vec<i32>) -> bool {
        let n = stones.len();
        let mut index: HashMap<i32, usize> = HashMap::new();
        for i in 0..n {
            index.insert(stones[i], i);
        }
        let mut dp: Vec<HashSet<i32>> = vec![HashSet::new(); n];
        dp[0].insert(0);
        for i in 0..n {
            let ks: Vec<i32> = dp[i].iter().cloned().collect();
            for k in ks {
                for step in [k - 1, k, k + 1] {
                    if step > 0 {
                        let pos = stones[i] + step;
                        if let Some(&j) = index.get(&pos) {
                            if j != i {
                                dp[j].insert(step);
                            }
                        }
                    }
                }
            }
        }
        !dp[n - 1].is_empty()
    }
}
