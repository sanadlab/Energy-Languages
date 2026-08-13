impl Solution {
    pub fn max_students(seats: Vec<Vec<char>>) -> i32 {
        let m = seats.len();
        if m == 0 { return 0; }
        let n = seats[0].len();
        let mut avail = vec![0i32; m];
        for i in 0..m {
            for j in 0..n {
                if j < seats[i].len() && seats[i][j] == '.' {
                    avail[i] |= 1 << j;
                }
            }
        }
        let full = 1i32 << n;
        let mut best = vec![-1i32; full as usize];
        best[0] = 0;
        for i in 0..m {
            let mut ndp = vec![-1i32; full as usize];
            for mask in 0..full {
                if (mask & avail[i]) != mask { continue; }
                if (mask & (mask << 1)) != 0 { continue; }
                let pc = mask.count_ones() as i32;
                for pmask in 0..full {
                    if best[pmask as usize] < 0 { continue; }
                    if (mask & (pmask << 1)) != 0 { continue; }
                    if (mask & (pmask >> 1)) != 0 { continue; }
                    let val = best[pmask as usize] + pc;
                    if val > ndp[mask as usize] { ndp[mask as usize] = val; }
                }
            }
            best = ndp;
        }
        *best.iter().max().unwrap()
    }
}
