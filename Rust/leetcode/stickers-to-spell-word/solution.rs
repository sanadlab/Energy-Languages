impl Solution {
    pub fn min_stickers(stickers: Vec<String>, target: String) -> i32 {
        let n = target.len();
        let full = (1usize << n) - 1;
        const INF: i32 = i32::MAX;
        let mut dp = vec![INF; 1 << n];
        dp[0] = 0;
        let tbytes = target.as_bytes();
        let cnt: Vec<[i32; 26]> = stickers.iter().map(|s| {
            let mut c = [0i32; 26];
            for &b in s.as_bytes() {
                c[(b - b'a') as usize] += 1;
            }
            c
        }).collect();
        for state in 0..=full {
            if dp[state] == INF {
                continue;
            }
            for c in &cnt {
                let mut avail = *c;
                let mut nxt = state;
                for i in 0..n {
                    if state & (1 << i) == 0 {
                        let idx = (tbytes[i] - b'a') as usize;
                        if avail[idx] > 0 {
                            avail[idx] -= 1;
                            nxt |= 1 << i;
                        }
                    }
                }
                if dp[state] + 1 < dp[nxt] {
                    dp[nxt] = dp[state] + 1;
                }
            }
        }
        if dp[full] == INF { -1 } else { dp[full] }
    }
}
