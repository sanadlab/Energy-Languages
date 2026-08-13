impl Solution {
    pub fn min_operations(s: String) -> i32 {
        let bytes = s.as_bytes();
        let n = bytes.len();
        let mut cnt = 0i32;
        for i in 0..n {
            let expected = if i % 2 == 0 { b'0' } else { b'1' };
            if bytes[i] != expected {
                cnt += 1;
            }
        }
        cnt.min(n as i32 - cnt)
    }
}
