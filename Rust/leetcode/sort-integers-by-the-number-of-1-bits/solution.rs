impl Solution {
    pub fn sort_by_bits(mut arr: Vec<i32>) -> Vec<i32> {
        arr.sort_by(|&a, &b| {
            let pa = (a as u32).count_ones();
            let pb = (b as u32).count_ones();
            pa.cmp(&pb).then(a.cmp(&b))
        });
        arr
    }
}
