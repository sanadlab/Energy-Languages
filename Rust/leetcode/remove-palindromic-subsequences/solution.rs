impl Solution {
    pub fn remove_palindrome_sub(s: String) -> i32 {
        if s.is_empty() {
            return 0;
        }
        let b = s.as_bytes();
        let (mut i, mut j) = (0usize, b.len() - 1);
        while i < j {
            if b[i] != b[j] {
                return 2;
            }
            i += 1;
            j -= 1;
        }
        1
    }
}
