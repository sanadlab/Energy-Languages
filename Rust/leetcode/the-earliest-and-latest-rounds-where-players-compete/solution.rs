use std::collections::HashMap;

impl Solution {
    pub fn earliest_and_latest(n: i32, first_player: i32, second_player: i32) -> Vec<i32> {
        if first_player == second_player {
            return vec![1, 1];
        }
        let (mut fp, mut sp) = (first_player, second_player);
        if fp > sp {
            std::mem::swap(&mut fp, &mut sp);
        }
        fn dp(n: i32, mut f: i32, mut s: i32, memo: &mut HashMap<i32, (i32, i32)>) -> (i32, i32) {
            if f + s == n + 1 {
                return (1, 1);
            }
            if f + s > n + 1 {
                let t = f;
                f = n + 1 - s;
                s = n + 1 - t;
            }
            let key = (n * 100 + f) * 100 + s;
            if let Some(&v) = memo.get(&key) {
                return v;
            }
            let half = (n + 1) / 2;
            let inf = 1 << 30;
            let (mut earliest, mut latest) = (inf, -inf);
            if s <= half {
                for i in 0..f {
                    for j in 0..(s - f) {
                        let (a, b) = dp(half, i + 1, i + j + 2, memo);
                        earliest = earliest.min(a);
                        latest = latest.max(b);
                    }
                }
            } else {
                let sp2 = n + 1 - s;
                let mid = n / 2;
                for i in 0..f {
                    for j in 0..(sp2 - f) {
                        let (a, b) = dp(half, i + 1, i + (mid - sp2) + j + 2, memo);
                        earliest = earliest.min(a);
                        latest = latest.max(b);
                    }
                }
            }
            let res = (earliest + 1, latest + 1);
            memo.insert(key, res);
            res
        }
        let mut memo: HashMap<i32, (i32, i32)> = HashMap::new();
        let r = dp(n, fp, sp, &mut memo);
        vec![r.0, r.1]
    }
}
