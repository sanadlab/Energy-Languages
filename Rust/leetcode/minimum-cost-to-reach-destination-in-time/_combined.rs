pub struct Solution;

impl Solution {
    pub fn min_cost(max_time: i32, edges: Vec<Vec<i32>>, passing_fees: Vec<i32>) -> i32 {
        let n = passing_fees.len();
        let mt = max_time as usize;
        const INF: i32 = 1 << 29;
        let mut adj: Vec<Vec<(usize, usize)>> = vec![Vec::new(); n];
        for e in &edges {
            if e.len() < 3 { continue; }
            let (x, y, w) = (e[0], e[1], e[2]);
            if x < 0 || x as usize >= n || y < 0 || y as usize >= n || w < 0 { continue; }
            adj[x as usize].push((y as usize, w as usize));
            adj[y as usize].push((x as usize, w as usize));
        }
        let mut dp = vec![vec![INF; n]; mt + 1];
        dp[0][0] = passing_fees[0];
        let mut ans = INF;
        for t in 0..=mt {
            for u in 0..n {
                let cur = dp[t][u];
                if cur >= INF { continue; }
                if u == n - 1 && cur < ans { ans = cur; }
                for &(v, w) in &adj[u] {
                    let nt = t + w;
                    if nt <= mt && cur + passing_fees[v] < dp[nt][v] {
                        dp[nt][v] = cur + passing_fees[v];
                    }
                }
            }
        }
        if ans >= INF { -1 } else { ans }
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::min_cost(20, vec![vec![1,2],vec![3,4]], vec![1,2,3,4,5]);
}
