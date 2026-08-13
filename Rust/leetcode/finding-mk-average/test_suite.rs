// LC-energy test suite (Rust) — finding-mk-average.
fn main() {
    let mut obj = MKAverage::new(5, 1);
    for v in [1,2,3,4,5,6,7,8,9,10] { obj.add_element(v); }
    let r = obj.calculate_mk_average();
    if r < -1 { println!("{}", r); }
}
