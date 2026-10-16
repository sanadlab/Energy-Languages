use std::collections::{HashMap, HashSet};

impl Solution {
    pub fn earliest_and_latest(n: i32, first_player: i32, second_player: i32) -> Vec<i32> {
        // Exact recursion over the positions of the two players: each round, every
        // other match may go either way, so enumerate how many winners finish ahead
        // of each player (only those counts matter for the next round).
        fn dp(m: i32, f: i32, s: i32, memo: &mut HashMap<i32, (i32, i32)>) -> (i32, i32) {
            let (f, s) = if f > s { (s, f) } else { (f, s) };
            if f + s == m + 1 {
                return (1, 1);
            }
            let key = m * 10000 + f * 100 + s;
            if let Some(&v) = memo.get(&key) {
                return v;
            }
            let step = |states: &HashSet<i32>, opts: &[i32]| -> HashSet<i32> {
                let mut next = HashSet::new();
                for &st in states.iter() {
                    let (bf, bs) = (st / 100, st % 100);
                    for &w in opts {
                        next.insert((bf + (w < f) as i32) * 100 + bs + (w < s) as i32);
                    }
                }
                next
            };
            let mut states: HashSet<i32> = HashSet::from([0]); // bf * 100 + bs
            for p in 1..=m / 2 {
                let q = m + 1 - p;
                states = if p == f || q == f {
                    step(&states, &[f])
                } else if p == s || q == s {
                    step(&states, &[s])
                } else {
                    step(&states, &[p, q])
                };
            }
            if m % 2 == 1 {
                states = step(&states, &[(m + 1) / 2]);
            }
            let (mut earliest, mut latest) = (i32::MAX, i32::MIN);
            for &st in states.iter() {
                let (e, l) = dp((m + 1) / 2, st / 100 + 1, st % 100 + 1, memo);
                earliest = earliest.min(e + 1);
                latest = latest.max(l + 1);
            }
            memo.insert(key, (earliest, latest));
            (earliest, latest)
        }
        let mut memo = HashMap::new();
        let (e, l) = dp(n, first_player, second_player, &mut memo);
        vec![e, l]
    }
}
