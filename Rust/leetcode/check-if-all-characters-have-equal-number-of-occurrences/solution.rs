impl Solution {
    pub fn are_occurrences_equal(s: String) -> bool {
        let mut counts = [0i32; 26];
        for c in s.chars() {
            counts[c as usize - 'a' as usize] += 1;
        }
        let mut f = -1;
        for &v in counts.iter() {
            if v == 0 {
                continue;
            }
            if f == -1 {
                f = v;
            } else if v != f {
                return false;
            }
        }
        true
    }
}
