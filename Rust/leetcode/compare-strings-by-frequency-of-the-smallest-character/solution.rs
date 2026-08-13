impl Solution {
    pub fn num_smaller_by_frequency(queries: Vec<String>, words: Vec<String>) -> Vec<i32> {
        fn f(s: &str) -> i32 {
            let mut mn = b'z';
            let mut cnt = 0;
            for &c in s.as_bytes() {
                if c < mn {
                    mn = c;
                    cnt = 1;
                } else if c == mn {
                    cnt += 1;
                }
            }
            cnt
        }
        let word_f: Vec<i32> = words.iter().map(|w| f(w)).collect();
        queries
            .iter()
            .map(|q| {
                let fq = f(q);
                word_f.iter().filter(|&&v| v > fq).count() as i32
            })
            .collect()
    }
}
