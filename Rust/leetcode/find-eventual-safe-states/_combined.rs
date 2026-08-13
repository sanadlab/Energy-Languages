pub struct Solution;

use std::collections::VecDeque;

impl Solution {
    pub fn eventual_safe_nodes(graph: Vec<Vec<i32>>) -> Vec<i32> {
        let n = graph.len();
        let mut rev: Vec<Vec<usize>> = vec![Vec::new(); n];
        let mut outdeg = vec![0i32; n];
        for u in 0..n {
            for &v in &graph[u] {
                if v >= 0 && (v as usize) < n {
                    rev[v as usize].push(u);
                    outdeg[u] += 1;
                }
            }
        }
        let mut q: VecDeque<usize> = VecDeque::new();
        for i in 0..n {
            if outdeg[i] == 0 {
                q.push_back(i);
            }
        }
        let mut safe = vec![false; n];
        while let Some(v) = q.pop_front() {
            safe[v] = true;
            for &u in &rev[v] {
                outdeg[u] -= 1;
                if outdeg[u] == 0 {
                    q.push_back(u);
                }
            }
        }
        (0..n).filter(|&i| safe[i]).map(|i| i as i32).collect()
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::eventual_safe_nodes(vec![vec![1,2],vec![3,4]]);
}
