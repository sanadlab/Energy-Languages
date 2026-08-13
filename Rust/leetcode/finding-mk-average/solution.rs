// Reference Rust solution for finding-mk-average.
struct MKAverage {
    m: usize,
    k: usize,
    stream: Vec<i32>,
}
impl MKAverage {
    fn new(m: i32, k: i32) -> Self {
        Self { m: m as usize, k: k as usize, stream: Vec::new() }
    }
    fn add_element(&mut self, num: i32) { self.stream.push(num); }
    fn calculate_mk_average(&self) -> i32 {
        if self.stream.len() < self.m { return -1; }
        let start = self.stream.len() - self.m;
        let mut w = self.stream[start..].to_vec();
        w.sort_unstable();
        let (lo, hi) = (self.k, self.m - self.k);
        if hi <= lo { return -1; }
        let sum: i64 = w[lo..hi].iter().map(|&x| x as i64).sum();
        (sum / (hi - lo) as i64) as i32
    }
}
