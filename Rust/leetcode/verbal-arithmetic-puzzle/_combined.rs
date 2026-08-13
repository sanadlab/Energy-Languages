pub struct Solution;

impl Solution {
    pub fn is_solvable(words: Vec<String>, result: String) -> bool {
        let word_bytes: Vec<Vec<u8>> = words.iter().map(|w| w.bytes().collect()).collect();
        let result_bytes: Vec<u8> = result.bytes().collect();
        let max_len = result_bytes.len();
        let mut assigned = [-1i32; 128];
        let mut used_digit = [false; 10];
        let mut leading = [false; 128];
        for w in &word_bytes {
            if w.len() > max_len {
                return false;
            }
            if w.len() > 1 {
                leading[w[0] as usize] = true;
            }
        }
        if result_bytes.len() > 1 {
            leading[result_bytes[0] as usize] = true;
        }
        Self::solve(
            0, 0, 0, max_len, &word_bytes, &result_bytes,
            &mut assigned, &mut used_digit, &leading,
        )
    }

    fn solve(
        col: usize, row: usize, carry: i32, max_len: usize,
        words: &Vec<Vec<u8>>, result: &Vec<u8>,
        assigned: &mut [i32; 128], used_digit: &mut [bool; 10], leading: &[bool; 128],
    ) -> bool {
        if col == max_len {
            return carry == 0;
        }
        if row < words.len() {
            let w = &words[row];
            if col >= w.len() {
                return Self::solve(col, row + 1, carry, max_len, words, result, assigned, used_digit, leading);
            }
            let ch = w[w.len() - 1 - col] as usize;
            if assigned[ch] != -1 {
                return Self::solve(col, row + 1, carry, max_len, words, result, assigned, used_digit, leading);
            }
            for d in 0..=9i32 {
                if !used_digit[d as usize] && !(d == 0 && leading[ch]) {
                    used_digit[d as usize] = true;
                    assigned[ch] = d;
                    if Self::solve(col, row + 1, carry, max_len, words, result, assigned, used_digit, leading) {
                        return true;
                    }
                    used_digit[d as usize] = false;
                    assigned[ch] = -1;
                }
            }
            return false;
        }
        let mut sum = carry;
        for w in words {
            if col < w.len() {
                sum += assigned[w[w.len() - 1 - col] as usize];
            }
        }
        let digit = sum % 10;
        let new_carry = sum / 10;
        let rch = result[result.len() - 1 - col] as usize;
        if assigned[rch] != -1 {
            if assigned[rch] == digit {
                return Self::solve(col + 1, 0, new_carry, max_len, words, result, assigned, used_digit, leading);
            }
            return false;
        }
        if used_digit[digit as usize] {
            return false;
        }
        if digit == 0 && leading[rch] {
            return false;
        }
        used_digit[digit as usize] = true;
        assigned[rch] = digit;
        if Self::solve(col + 1, 0, new_carry, max_len, words, result, assigned, used_digit, leading) {
            return true;
        }
        used_digit[digit as usize] = false;
        assigned[rch] = -1;
        false
    }
}
// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::is_solvable(vec![String::from("a"),String::from("b"),String::from("c")], String::from("abcde"));
}
