use std::collections::HashMap;

impl Solution {
    pub fn is_scramble(s1: String, s2: String) -> bool {
        if s1.len() != s2.len() {
            return false;
        }
        fn sorted_equal(a: &str, b: &str) -> bool {
            let mut c = [0i32; 26];
            let ab = a.as_bytes();
            let bb = b.as_bytes();
            for i in 0..ab.len() {
                c[(ab[i] - b'a') as usize] += 1;
                c[(bb[i] - b'a') as usize] -= 1;
            }
            c.iter().all(|&x| x == 0)
        }
        fn helper(a: &str, b: &str, memo: &mut HashMap<(String, String), bool>) -> bool {
            if a == b {
                return true;
            }
            let key = (a.to_string(), b.to_string());
            if let Some(&v) = memo.get(&key) {
                return v;
            }
            if !sorted_equal(a, b) {
                memo.insert(key, false);
                return false;
            }
            let n = a.len();
            let mut res = false;
            for i in 1..n {
                if (helper(&a[..i], &b[..i], memo) && helper(&a[i..], &b[i..], memo))
                    || (helper(&a[..i], &b[n - i..], memo) && helper(&a[i..], &b[..n - i], memo))
                {
                    res = true;
                    break;
                }
            }
            memo.insert(key, res);
            res
        }
        let mut memo: HashMap<(String, String), bool> = HashMap::new();
        helper(&s1, &s2, &mut memo)
    }
}
